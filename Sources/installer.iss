; ############################################################################
; Rabiraag Bangla Keyboard v3.0 Installer
; Created for Habitat Whisper by Bonanto
; Dedicated to Her
; ############################################################################

[Setup]
AppId=RabiraagKeyboard_v3
AppName=Rabiraag Bangla Keyboard
AppVersion=3.0
AppPublisher=Habitat Whisper
VersionInfoVersion=3.0.0.0
VersionInfoCompany=Habitat Whisper
VersionInfoDescription=Rabiraag Bangla Keyboard Installer
VersionInfoCopyright=(c) 2026 Shyamal Kr Biswas (Bonanto), Habitat Whisper
VersionInfoProductName=Rabiraag Bangla Keyboard
VersionInfoProductVersion=3.0.0.0
UsedUserAreasWarning=no
DefaultDirName={autopf}\RabiraagKeyboard
DisableProgramGroupPage=yes
DisableDirPage=yes
OutputBaseFilename=Rabiraag_v3_Setup

; Prevent false-positive heuristic flags
Compression=lzma
SolidCompression=no

ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
SetupIconFile=rabiraag.ico
UninstallDisplayIcon={app}\unins000.exe
LicenseFile=license.rtf

[Files]
Source: "keyboard.bmp"; Flags: dontcopy
Source: "rabiraag.ico"; Flags: dontcopy

; --- Keyboard Layout DLLs ---
Source: "amd64\rabiraag.dll"; DestDir: "{sys}"; Check: Is64BitInstallMode; Flags: uninsrestartdelete restartreplace
Source: "wow64\rabiraag.dll"; DestDir: "{syswow64}"; Check: Is64BitInstallMode; Flags: uninsrestartdelete restartreplace
Source: "x86\rabiraag.dll"; DestDir: "{sys}"; Check: not Is64BitInstallMode; Flags: uninsrestartdelete restartreplace

; --- Office 365 AltGr Fix Helper ---
; Deployed to {app} and renamed to a common name regardless of architecture.
; The Run registry key (added below) launches it at user logon.
Source: "helper_svc\rabiraag_helper_x64.exe"; DestDir: "{app}"; DestName: "rabiraag_helper.exe"; Check: Is64BitInstallMode and InstallHelper; Flags: ignoreversion
Source: "helper_svc\rabiraag_helper_x86.exe"; DestDir: "{app}"; DestName: "rabiraag_helper.exe"; Check: (not Is64BitInstallMode) and InstallHelper; Flags: ignoreversion

; --- Google Noto Fonts ---
Source: "Fonts\NotoSansBengali-Regular.ttf"; DestDir: "{autofonts}"; FontInstall: "Noto Sans Bengali"; Flags: onlyifdoesntexist uninsneveruninstall; Check: InstallFonts
Source: "Fonts\NotoSansBengali-Bold.ttf"; DestDir: "{autofonts}"; FontInstall: "Noto Sans Bengali Bold"; Flags: onlyifdoesntexist uninsneveruninstall; Check: InstallFonts
Source: "Fonts\NotoSerifBengali-Regular.ttf"; DestDir: "{autofonts}"; FontInstall: "Noto Serif Bengali"; Flags: onlyifdoesntexist uninsneveruninstall; Check: InstallFonts
Source: "Fonts\NotoSerifBengali-Bold.ttf"; DestDir: "{autofonts}"; FontInstall: "Noto Serif Bengali Bold"; Flags: onlyifdoesntexist uninsneveruninstall; Check: InstallFonts

[Registry]
; --- Keyboard Layout Registration ---

; 64-bit Registry Hive
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; Flags: uninsdeletekey
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Text"; ValueData: "Rabiraag Bangla Keyboard"
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout File"; ValueData: "rabiraag.dll"
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Id"; ValueData: "00c0"
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Display Name"; ValueData: "@%SystemRoot%\system32\rabiraag.dll,-1000"
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Product Code"; ValueData: "{{41a98474-b8b5-4f72-8114-bc4a031e7cc8}"
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Custom Language Name"; ValueData: "Bangla (India)"
Root: HKLM64; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Custom Language Display Name"; ValueData: "@%SystemRoot%\system32\rabiraag.dll,-1100"

; 32-bit Registry Hive
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; Flags: uninsdeletekey
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Text"; ValueData: "Rabiraag Bangla Keyboard"
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout File"; ValueData: "rabiraag.dll"
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Id"; ValueData: "00c0"
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Display Name"; ValueData: "@%SystemRoot%\system32\rabiraag.dll,-1000"
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Layout Product Code"; ValueData: "{{41a98474-b8b5-4f72-8114-bc4a031e7cc8}"
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Custom Language Name"; ValueData: "Bangla (India)"
Root: HKLM32; Subkey: "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445"; ValueType: string; ValueName: "Custom Language Display Name"; ValueData: "@%SystemRoot%\system32\rabiraag.dll,-1100"

; --- AltGr Helper Auto-Start ---
; Written to HKCU so it launches for the installing user at each logon.
; uninsdeletevalue ensures clean removal on uninstall.
; The InstallHelper Check prevents writing this key if the user opted out.
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "RabiraagHelper"; ValueData: """{app}\rabiraag_helper.exe"""; Flags: uninsdeletevalue; Check: InstallHelper

[Code]
var
  FontPage, MaintenancePage: TWizardPage;
  KeyImage: TBitmapImage;
  NativeLabel, GlobalFooterLink, GitHubLink, GlobalFooterInfo, MaintenanceDesc: TNewStaticText;
  FontCheckBox, HelperCheckBox, UninstallFontsCheckBox: TCheckBox;
  RepairRadio, UninstallRadio: TNewRadioButton;
  IsUpgrading: Boolean;
  IsSilentExit: Boolean;
  UninstallFontsWanted: Boolean;

// ── Check functions called by [Files] and [Registry] ──────────────────────

function IsLayoutInstalled: Boolean;
begin
  Result :=
    RegKeyExists(HKLM64, 'SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445') or
    RegKeyExists(HKLM32, 'SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0000445');
end;

function InstallFonts: Boolean;
begin
  Result := FontCheckBox.Checked or IsUpgrading;
end;

function InstallHelper: Boolean;
begin
  // During upgrade the helper is always refreshed (re-copied) so the
  // checkbox state is irrelevant and we return True unconditionally.
  Result := HelperCheckBox.Checked or IsUpgrading;
end;

// ── Font removal ──────────────────────────────────────────────────────────

procedure RemoveNotoFonts;
var
  FontsDir: String;
  FilesInUse: Boolean;
begin
  FontsDir := ExpandConstant('{autofonts}\');
  FilesInUse := False;
  if not DeleteFile(FontsDir + 'NotoSansBengali-Regular.ttf')  then FilesInUse := True;
  if not DeleteFile(FontsDir + 'NotoSansBengali-Bold.ttf')     then FilesInUse := True;
  if not DeleteFile(FontsDir + 'NotoSerifBengali-Regular.ttf') then FilesInUse := True;
  if not DeleteFile(FontsDir + 'NotoSerifBengali-Bold.ttf')    then FilesInUse := True;

  RegDeleteValue(HKLM64, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Sans Bengali (TrueType)');
  RegDeleteValue(HKLM64, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Sans Bengali Bold (TrueType)');
  RegDeleteValue(HKLM64, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Serif Bengali (TrueType)');
  RegDeleteValue(HKLM64, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Serif Bengali Bold (TrueType)');

  RegDeleteValue(HKLM32, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Sans Bengali (TrueType)');
  RegDeleteValue(HKLM32, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Sans Bengali Bold (TrueType)');
  RegDeleteValue(HKLM32, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Serif Bengali (TrueType)');
  RegDeleteValue(HKLM32, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'Noto Serif Bengali Bold (TrueType)');

  if FilesInUse then
    MsgBox('Some font files could not be removed because they are currently in use.' + #13#10 + #13#10 + 'The fonts have been unregistered. The files at ' + FontsDir + ' can be manually deleted after restarting your computer.', mbInformation, MB_OK);
end;

// ── UI helpers ─────────────────────────────────────────────────────────────

procedure UpdateMaintenanceButton;
begin
  if RepairRadio.Checked then WizardForm.NextButton.Caption := 'Repair'
  else WizardForm.NextButton.Caption := 'Uninstall';
end;

procedure MaintenanceRadioClick(Sender: TObject);
begin
  UpdateMaintenanceButton;
  // Enable the font removal checkbox only if the Uninstall radio is selected
  UninstallFontsCheckBox.Enabled := UninstallRadio.Checked;
end;

procedure FooterLinkClick(Sender: TObject);
var ErrorCode: Integer;
begin
  ShellExec('open', 'https://gitlab.com/bonanto/rabiraag-keyboard',
            '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure GitHubLinkClick(Sender: TObject);
var ErrorCode: Integer;
begin
  ShellExec('open', 'https://github.com/bonanto/rabiraag',
            '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

// ── Wizard initialisation ──────────────────────────────────────────────────

procedure InitializeWizard;
var ImageFileName: String;
begin
  IsUpgrading := IsLayoutInstalled;
  IsSilentExit := False;

  WizardForm.ReadyLabel.Font.Style := [fsBold];

  // --- INSTALLATION PAGE ---
  FontPage := CreateCustomPage(wpWelcome,
                               'Installation Options',
                               'Finalize your Rabiraag Experience');
                               
  ExtractTemporaryFile('keyboard.bmp');
  ImageFileName := ExpandConstant('{tmp}\keyboard.bmp');

  KeyImage := TBitmapImage.Create(FontPage);
  KeyImage.Parent := FontPage.Surface;
  KeyImage.Bitmap.LoadFromFile(ImageFileName);
  KeyImage.Left := 0; KeyImage.Top := 0; KeyImage.AutoSize := True;

  NativeLabel := TNewStaticText.Create(FontPage);
  NativeLabel.Parent := FontPage.Surface;
  NativeLabel.Caption :=
    'Rabiraag Bangla Keyboard v3.0 (Build 6202.26) by Bonanto' + #13#10#13#10 +
    'This installation will deploy a native Windows layout. ' +
    'NO Background process unless you Install Helper (Recommended for Office 2024/365/Windows 11) and ' +
    'NO memory overhead, ensuring a seamless typing experience.';
    
  NativeLabel.WordWrap := True;
  NativeLabel.AutoSize := False;
  NativeLabel.Left := 0;
  NativeLabel.Width := FontPage.SurfaceWidth;
  NativeLabel.Height := ScaleY(85);
  NativeLabel.Top := KeyImage.Top + KeyImage.Height + ScaleY(15);
  NativeLabel.Font.Style := [fsBold];

  // Fonts checkbox
  FontCheckBox := TCheckBox.Create(FontPage);
  FontCheckBox.Parent := FontPage.Surface;
  FontCheckBox.Caption := 'Install Google Noto Sans and Serif Bengali fonts (Recommended)';
  FontCheckBox.Left := 0;
  FontCheckBox.Top := NativeLabel.Top + NativeLabel.Height + ScaleY(5);
  FontCheckBox.Width := FontPage.SurfaceWidth;
  FontCheckBox.Checked := True;

  // Helper checkbox - anchored directly below FontCheckBox
  HelperCheckBox := TCheckBox.Create(FontPage);
  HelperCheckBox.Parent := FontPage.Surface;
  HelperCheckBox.Caption := 'Install Office 365 AltGr fix (Recommended for Office 2024/365)';
  HelperCheckBox.Left := 0;
  HelperCheckBox.Top := FontCheckBox.Top + FontCheckBox.Height + ScaleY(4);
  HelperCheckBox.Width := FontPage.SurfaceWidth;
  HelperCheckBox.Checked := True;

  // --- MAINTENANCE PAGE ---
  MaintenancePage := CreateCustomPage(wpWelcome,
                                      'Maintenance Options',
                                      'Modify or remove existing installation');
                                      
  MaintenanceDesc := TNewStaticText.Create(MaintenancePage);
  MaintenanceDesc.Parent := MaintenancePage.Surface;
  MaintenanceDesc.Caption := 'Rabiraag is already installed. Choose an action:';
  MaintenanceDesc.Left := 0;
  MaintenanceDesc.Top := 0;

  RepairRadio := TNewRadioButton.Create(MaintenancePage);
  RepairRadio.Parent := MaintenancePage.Surface;
  RepairRadio.Caption := 'Repair/Refresh (Re-registers and updates the taskbar layout)';
  RepairRadio.Left := ScaleX(10);
  RepairRadio.Top := MaintenanceDesc.Top + ScaleY(30);
  RepairRadio.Width := MaintenancePage.SurfaceWidth;
  RepairRadio.Checked := True;
  RepairRadio.OnClick := @MaintenanceRadioClick;

  UninstallRadio := TNewRadioButton.Create(MaintenancePage);
  UninstallRadio.Parent := MaintenancePage.Surface;
  UninstallRadio.Caption := 'Completely remove the layout and settings from the system';
  UninstallRadio.Left := ScaleX(10);
  UninstallRadio.Top := RepairRadio.Top + ScaleY(30);
  UninstallRadio.Width := MaintenancePage.SurfaceWidth;
  UninstallRadio.OnClick := @MaintenanceRadioClick;

  // Font removal checkbox under Uninstall
  UninstallFontsCheckBox := TCheckBox.Create(MaintenancePage);
  UninstallFontsCheckBox.Parent := MaintenancePage.Surface;
  UninstallFontsCheckBox.Caption := 'Also remove Google Noto Bengali fonts';
  UninstallFontsCheckBox.Left := UninstallRadio.Left + ScaleX(15);
  UninstallFontsCheckBox.Top := UninstallRadio.Top + UninstallRadio.Height + ScaleY(5);
  UninstallFontsCheckBox.Width := MaintenancePage.SurfaceWidth;
  UninstallFontsCheckBox.Checked := False; // Default to false
  UninstallFontsCheckBox.Enabled := False; // Disabled until Uninstall Radio is selected

  // --- FOOTER ---
  GitHubLink := TNewStaticText.Create(WizardForm);
  GitHubLink.Parent := WizardForm;
  GitHubLink.Caption := 'GitHub Repo';
  GitHubLink.Cursor := crHand;
  GitHubLink.Font.Color := clBlue;
  GitHubLink.Font.Style := [fsUnderline];
  GitHubLink.Left := ScaleX(15);
  GitHubLink.Top := WizardForm.CancelButton.Top - ScaleY(2);
  GitHubLink.OnClick := @GitHubLinkClick;

  GlobalFooterLink := TNewStaticText.Create(WizardForm);
  GlobalFooterLink.Parent := WizardForm;
  GlobalFooterLink.Caption := 'GitLab (Mirror) Repo';
  GlobalFooterLink.Cursor := crHand;
  GlobalFooterLink.Font.Color := clBlue;
  GlobalFooterLink.Font.Style := [fsUnderline];
  GlobalFooterLink.Left := GitHubLink.Left + GitHubLink.Width + ScaleX(15);
  GlobalFooterLink.Top := GitHubLink.Top;
  GlobalFooterLink.OnClick := @FooterLinkClick;

  GlobalFooterInfo := TNewStaticText.Create(WizardForm);
  GlobalFooterInfo.Parent := WizardForm;
  GlobalFooterInfo.Caption := '(c) 2026 Shyamal Kr Biswas (Bonanto), Habitat Whisper';
  GlobalFooterInfo.Font.Color := clGrayText;
  GlobalFooterInfo.Left := ScaleX(15);
  GlobalFooterInfo.Top := GlobalFooterLink.Top + ScaleY(16);
end;

// ── Page visibility ────────────────────────────────────────────────────────

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if IsUpgrading then begin
    if (PageID = FontPage.ID) or (PageID = wpLicense) or
       (PageID = wpReady) or (PageID = wpSelectDir) then
      Result := True;
  end else begin
    if PageID = MaintenancePage.ID then
      Result := True;
  end;
end;

// ── Maintenance uninstall flow ─────────────────────────────────────────────

function NextButtonClick(CurPageID: Integer): Boolean;
var
  UninstallStr, Params: String;
  ResCode: Integer;
begin
  Result := True;
  if IsUpgrading and (CurPageID = MaintenancePage.ID) then begin
    if UninstallRadio.Checked then begin
      if RegQueryStringValue(HKLM64, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\RabiraagKeyboard_v3_is1', 'UninstallString', UninstallStr) or
         RegQueryStringValue(HKLM32, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\RabiraagKeyboard_v3_is1', 'UninstallString', UninstallStr) then
      begin
        
        // Pass command line flags to the Uninstaller so it knows what the user selected
        Params := ' /MAINTENANCE=1';
        if UninstallFontsCheckBox.Checked then
          Params := Params + ' /REMOVEFONTS=1'
        else
          Params := Params + ' /REMOVEFONTS=0';

        // Launch the uninstaller and let it prompt the user with its standard UI
        Exec(RemoveQuotes(UninstallStr), Params, '', SW_SHOW, ewWaitUntilTerminated, ResCode);

        // Close the Setup Wizard completely once the uninstaller finishes or is cancelled
        IsSilentExit := True;
        WizardForm.Close;
        Result := False;
      end;
    end;
  end;
end;

// ── Post-install actions ───────────────────────────────────────────────────

procedure CurStepChanged(CurStep: TSetupStep);
var
  PSCommand: String;
  ResCode: Integer;
begin
  if CurStep = ssPostInstall then begin

    // Register the keyboard layout for the current user
    PSCommand :=
      '-NoProfile -Command "$L=Get-WinUserLanguageList; ' +
      '$B=$L | Where-Object LanguageTag -eq ''bn-IN''; ' +
      'if (-not $B) { $L.Add(''bn-IN''); ' +
      '$B=$L | Where-Object LanguageTag -eq ''bn-IN''; $B.InputMethodTips.Clear() }; ' +
      'if ($B.InputMethodTips -notcontains ''0445:a0000445'' -and ' +
      '$B.InputMethodTips -notcontains ''0445:A0000445'') ' +
      '{ $B.InputMethodTips.Add(''0445:a0000445'') }; ' +
      'Set-WinUserLanguageList $L -Force"';
    ExecAsOriginalUser('powershell.exe', PSCommand, '',
                       SW_HIDE, ewWaitUntilTerminated, ResCode);

    // Flush MUI/layout cache so Settings picks up the new keyboard name
    RegDeleteKeyIncludingSubkeys(HKCU, 'Software\Microsoft\CTF\SortOrder');

    // Launch the helper immediately so the fix is active without a logoff.
    if InstallHelper then
      ExecAsOriginalUser(ExpandConstant('{app}\rabiraag_helper.exe'),
                         '', '', SW_HIDE, ewNoWait, ResCode);
  end;
end;

// ── Uninstall actions ──────────────────────────────────────────────────────

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  PSCommand: String;
  ResCode: Integer;
begin
  if CurUninstallStep = usUninstall then begin

    // Terminate the helper process before files are deleted
    Exec('taskkill.exe', '/F /IM rabiraag_helper.exe', '',
         SW_HIDE, ewWaitUntilTerminated, ResCode);

    // Check if uninstaller was launched from our Maintenance page
    if ExpandConstant('{param:MAINTENANCE|0}') = '1' then begin
      // Grab the font removal decision seamlessly from the command line
      UninstallFontsWanted := ExpandConstant('{param:REMOVEFONTS|0}') = '1';
    end else begin
      // Launched via Windows Settings/Control Panel - trigger manual prompt
      UninstallFontsWanted := MsgBox('Would you like to also remove the Google Noto Bengali fonts installed with Rabiraag?', mbConfirmation, MB_YESNO) = IDYES;
    end;

    if UninstallFontsWanted then
      RemoveNotoFonts;

    // Remove the layout from the taskbar
    PSCommand :=
      '-NoProfile -Command "$L=Get-WinUserLanguageList; ' +
      '$B=$L | Where-Object LanguageTag -eq ''bn-IN''; ' +
      'if ($B) { $null=$B.InputMethodTips.Remove(''0445:a0000445''); ' +
      '$null=$B.InputMethodTips.Remove(''0445:A0000445''); ' +
      'if ($B.InputMethodTips.Count -eq 0) { $null=$L.Remove($B) }; ' +
      'Set-WinUserLanguageList $L -Force }"';
    Exec('powershell.exe', PSCommand, '', SW_HIDE, ewWaitUntilTerminated, ResCode);
  end;
end;

// ── Misc ───────────────────────────────────────────────────────────────────

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if IsSilentExit then begin Confirm := False; Cancel := True; end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if IsUpgrading and (CurPageID = MaintenancePage.ID) then
    UpdateMaintenanceButton;

  if CurPageID = wpFinished then
    WizardForm.FinishedHeadingLabel.Caption := 'Installation Successful! শুভেচ্ছা';
end;

function NeedRestart(): Boolean;
begin
  Result := False;
end;