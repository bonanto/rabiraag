/*
 * rabiraag_helper.c
 * Rabiraag Bangla Keyboard - AltGr Compatibility Helper
 *
 * PURPOSE:
 * Modern office applications often intercept Ctrl+Alt+Key combinations as macro 
 * shortcuts, which conflicts with standard AltGr character assignments in custom 
 * keyboard layouts. This helper utilizes a low-level keyboard hook to detect 
 * AltGr+Key events specifically when the Rabiraag layout is active. It intercepts 
 * the event and injects the correct Unicode character without modifying the 
 * system's Control or Alt key states, effectively bypassing application-level 
 * shortcut handlers.
 *
 * DESIGN PRINCIPLES:
 * 1. Key states (Ctrl/Alt) are never artificially released or restored via SendInput. 
 * Injection relies strictly on KEYEVENTF_UNICODE events, which bypass virtual-key 
 * shortcut handlers.
 * 2. Injected events are tagged with a session-unique runtime signature to prevent 
 * the hook from processing its own output (preventing infinite loops).
 * 3. Interception is strictly isolated to threads where the Rabiraag layout 
 * (KLID 0x0445 / 0x0845) is actively in the foreground.
 * 4. A hardcoded named mutex ensures strict single-instance execution system-wide.
 * 5. Execution is entirely headless (no window, no system tray icon).
 *
 * COMPILATION INSTRUCTIONS (MinGW, Pure C, No CRT):
 *
 * 64-bit:
 * windres rabiraag_helper.rc -O coff -o res64.o
 * gcc -O3 -mwindows -m64 -nostdlib -ffreestanding ^
 * rabiraag_helper.c res64.o -o rabiraag_helper_x64.exe ^
 * -luser32 -lkernel32 -lntdll
 *
 * 32-bit:
 * windres -F pe-i386 rabiraag_helper.rc -O coff -o res32.o
 * gcc -O3 -mwindows -nostdlib -ffreestanding ^
 * rabiraag_helper.c res32.o -o rabiraag_helper_x86.exe ^
 * -luser32 -lkernel32 -lntdll "-Wl,--enable-stdcall-fixup"
 */

#include <windows.h>
#include <stdbool.h>
#include <stddef.h>

// ── Custom Memory Initialization ──────────────────────────────────────────────
// Custom memset implementation, required due to the -nostdlib compiler flag.
// Prevents implicit memset calls by GCC for zero-initialized local arrays 
// and allows safe, explicit buffer clearing.
void* __cdecl memset(void* dest, int c, size_t count) {
    char* bytes = (char*)dest;
    while (count--) {
        *bytes++ = (char)c;
    }
    return dest;
}

// ── Runtime Event Signature ───────────────────────────────────────────────────
// Initialized prior to hook installation. Used in dwExtraInfo of injected INPUT 
// events to allow the hook callback to ignore self-generated events.
static ULONG_PTR HOOK_SIGNATURE = 0;

static HHOOK g_hHook = NULL;

// ── Keyboard Layout Verification ──────────────────────────────────────────────
static bool IsRabiraagActive(void)
{
    HWND hwnd = GetForegroundWindow();
    if (!hwnd) return false;
    DWORD tid   = GetWindowThreadProcessId(hwnd, NULL);
    HKL   hkl   = GetKeyboardLayout(tid);
    WORD  langId = LOWORD((DWORD)(ULONG_PTR)hkl);
    // 0x0445 = bn-IN (Rabiraag), 0x0845 = bn-BD
    return (langId == 0x0445 || langId == 0x0845);
}

// ── Unicode Event Injection ───────────────────────────────────────────────────
// Dispatches KEYEVENTF_UNICODE events exclusively. 
static void InjectUnicode(int count, const WORD* cp)
{
    // Buffer sized for a maximum of 4 characters per ligature * 2 (down/up)
    INPUT inputs[8];
    memset(inputs, 0, sizeof(inputs));

    for (int i = 0; i < count; ++i) {
        inputs[i*2].type           = INPUT_KEYBOARD;
        inputs[i*2].ki.wScan       = cp[i];
        inputs[i*2].ki.dwFlags     = KEYEVENTF_UNICODE;
        inputs[i*2].ki.dwExtraInfo = HOOK_SIGNATURE;

        inputs[i*2 + 1]            = inputs[i*2];
        inputs[i*2 + 1].ki.dwFlags = KEYEVENTF_UNICODE | KEYEVENTF_KEYUP;
    }

    SendInput(count * 2, inputs, sizeof(INPUT));
}

// ── Character Mapping Tables ──────────────────────────────────────────────────
// Derived directly from the MSKLC layout file configurations.
// Represents AltGr (Right-Alt / Ctrl+Alt) mappings.

typedef struct {
    DWORD vk;
    int   charCount;
    WORD  chars[4];
} Entry;

// AltGr Layer (State 6)
static const Entry ALTGR[] = {
    { '1',           1, {0x09f4}             },  // ৴ Bengali Currency Numerator One
    { '2',           1, {0x09f5}             },  // ৵ Bengali Currency Numerator Two
    { '3',           1, {0x09f6}             },  // ৶ Bengali Currency Numerator Three
    { '4',           1, {0x0024}             },  // $ Dollar Sign
    { '5',           1, {0x09f8}             },  // ৸
    { '6',           1, {0x09f9}             },  // ৹
    { '7',           1, {0x09f2}             },  // ৲ Bengali Rupee Mark
    { '8',           1, {0x09fb}             },  // ৻
    { 'A',           1, {0x0986}             },  // আ Bengali Letter AA
    { 'B',           1, {0x09f1}             },  // ৱ Bengali Letter Ra with Lower Diagonal
    { 'C',           3, {0x099e, 0x09cd, 0x099a} },  // ঞ্চ (ligature)
    { 'D',           3, {0x09a1, 0x09cd, 0x09a1} },  // ড্ড (ligature)
    { 'E',           1, {0x098f}             },  // এ Bengali Letter E
    { 'F',           1, {0x0980}             },  // ঀ Bengali Anji
    { 'G',           3, {0x099c, 0x09cd, 0x099e} },  // জ্ঞ (ligature)
    { 'H',           3, {0x09b9, 0x09cd, 0x09ae} },  // হ্ম (ligature)
    { 'I',           1, {0x0987}             },  // ই Bengali Letter I
    { 'J',           2, {0x099c, 0x09bc}     },  // জ় (ligature)
    { 'K',           3, {0x0995, 0x09cd, 0x0995} },  // ক্ক (ligature)
    { 'L',           1, {0x09e1}             },  // ৡ Bengali Letter Vocalic LL
    { 'N',           3, {0x09b7, 0x09cd, 0x09a3} },  // ষ্ণ (ligature)
    { 'O',           1, {0x0993}             },  // ও Bengali Letter O
    { 'R',           1, {0x09dd}             },  // ঢ় Bengali Letter RHA
    { 'S',           1, {0x09b7}             },  // ষ Bengali Letter SSA
    { 'T',           1, {0x09ce}             },  // ৎ Bengali Letter Khanda Ta
    { 'U',           1, {0x0989}             },  // উ Bengali Letter U
    { 'V',           3, {0x09a6, 0x09cd, 0x09a7} },  // দ্ধ (ligature)
    { 'X',           1, {0x09fa}             },  // ৺ Bengali Isshar
    { 'Y',           2, {0x09cd, 0x09af}     },  // ্য (ligature: Virama+Ya)
    { 'Z',           1, {0x0983}             },  // ঃ Bengali Sign Visarga
    { VK_OEM_3,      1, {0x007e}             },  // ~ Tilde  (` key)
};

// AltGr+Shift Layer (State 7)
static const Entry ALTGR_SHIFT[] = {
    { '4',           1, {0x09f7}             },  // ৷ Bengali Currency Numerator Four
    { 'B',           1, {0x09f0}             },  // ৰ Bengali Letter Ra with Middle Diagonal
    { 'E',           1, {0x0990}             },  // ঐ Bengali Letter AI
    { 'H',           1, {0x09fe}             },  // ৾ Bengali Sandhi Mark
    { 'I',           1, {0x0988}             },  // ঈ Bengali Letter II
    { 'J',           3, {0x099e, 0x09cd, 0x099c} },  // ঞ্জ (ligature)
    { 'L',           1, {0x09e2}             },  // ৢ Bengali Vowel Sign Vocalic L
    { 'M',           1, {0x09fc}             },  // ৼ Bengali Letter Vedic Anusvara
    { 'N',           1, {0x09e3}             },  // ৣ Bengali Vowel Sign Vocalic LL
    { 'O',           1, {0x0994}             },  // ঔ Bengali Letter AU
    { 'R',           1, {0x098b}             },  // ঋ Bengali Letter Vocalic R
    { 'T',           1, {0x09f3}             },  // ৳ Bengali Rupee Sign
    { 'U',           1, {0x098a}             },  // ঊ Bengali Letter UU
    { 'W',           1, {0x0950}             },  // ॐ Devanagari Om
    { 'Y',           1, {0x09d7}             },  // ৗ Bengali AU Length Mark
    { 'Z',           1, {0x09c4}             },  // ৄ Bengali Vowel Sign Vocalic RR
    { VK_OEM_3,      1, {0x200d}             },  // ZWJ  (` key + Shift)
    { VK_OEM_7,      1, {0x09fd}             },  // ৽ Bengali Abbreviation Sign  (' key)
    { VK_OEM_PERIOD, 1, {0x0965}             },  // ॥ Devanagari Double Danda    (. key)
};

// ── Hook Procedure ────────────────────────────────────────────────────────────
LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
{
    if (nCode != HC_ACTION)
        return CallNextHookEx(g_hHook, nCode, wParam, lParam);

    if (wParam != WM_KEYDOWN && wParam != WM_SYSKEYDOWN)
        return CallNextHookEx(g_hHook, nCode, wParam, lParam);

    KBDLLHOOKSTRUCT* kb = (KBDLLHOOKSTRUCT*)lParam;

    // Ignore helper-generated events
    if (kb->dwExtraInfo == HOOK_SIGNATURE)
        return CallNextHookEx(g_hHook, nCode, wParam, lParam);

    // GetKeyState reflects the modifier state of the current message being processed.
    // Preferred over GetAsyncKeyState to avoid heuristic flags from security software.
    bool lCtrl = (GetKeyState(VK_LCONTROL) & 0x8000) != 0;
    bool rAlt  = (GetKeyState(VK_RMENU)    & 0x8000) != 0;

    if (!lCtrl || !rAlt)
        return CallNextHookEx(g_hHook, nCode, wParam, lParam);

    // Execution isolated to active Rabiraag inputs
    if (!IsRabiraagActive())
        return CallNextHookEx(g_hHook, nCode, wParam, lParam);

    bool  shiftDown = (GetKeyState(VK_SHIFT) & 0x8000) != 0;
    DWORD vk        = kb->vkCode;

    const Entry* table     = shiftDown ? ALTGR_SHIFT : ALTGR;
    size_t       tableSize = shiftDown
                             ? (sizeof(ALTGR_SHIFT) / sizeof(ALTGR_SHIFT[0]))
                             : (sizeof(ALTGR)       / sizeof(ALTGR[0]));

    for (size_t i = 0; i < tableSize; ++i) {
        if (table[i].vk == vk) {
            InjectUnicode(table[i].charCount, table[i].chars);
            return 1; // Event consumed
        }
    }

    // Key not mapped; pass through normally
    return CallNextHookEx(g_hHook, nCode, wParam, lParam);
}

// ── Process Entry Point ───────────────────────────────────────────────────────
void __stdcall WinMainCRTStartup(void)
{
    HINSTANCE hInstance = GetModuleHandleW(NULL);

    // XOR combination of PID and system tick count ensures unpredictability 
    // across sessions to prevent external event spoofing.
    HOOK_SIGNATURE = (ULONG_PTR)GetCurrentProcessId() ^
                     (ULONG_PTR)GetTickCount64()      ^
                     0x52425247UL;

    // Fixed mutex name ensures only a single instance runs globally, 
    // regardless of the execution path.
    HANDLE hMutex = CreateMutexW(NULL, TRUE,
                                 L"RabiraagBanglaKeyboardHelper_SingleInstance");
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        CloseHandle(hMutex);
        ExitProcess(0);
    }

    g_hHook = SetWindowsHookExW(WH_KEYBOARD_LL, LowLevelKeyboardProc,
                                hInstance, 0);
    if (!g_hHook) {
        ReleaseMutex(hMutex);
        CloseHandle(hMutex);
        ExitProcess(1);
    }

    // Standard message pump required to service the Windows hook
    MSG msg;
    while (GetMessageW(&msg, NULL, 0, 0) > 0) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }

    UnhookWindowsHookEx(g_hHook);
    ReleaseMutex(hMutex);
    CloseHandle(hMutex);
    ExitProcess(0);
}