#define MyAppVersion "0.1.1"
#define MyAppExeName "QuizApp.exe"

[Setup]
; AppId duy nhất để Windows nhận diện bản cập nhật
AppId={{D3F7B2A1-0E34-4A8E-9C8F-123456789ABC}}
AppName=QuizApp
AppVersion={#MyAppVersion}
AppPublisher=Mr.NoBody

; --- CONFIG HIỂN THỊ TRONG CONTROL PANEL ---
UninstallDisplayName=QuizApp
; Lấy icon từ chính file exe sau khi cài
UninstallDisplayIcon={app}\{#MyAppExeName}

; --- THIẾT LẬP THƯ MỤC & ICON ---
DefaultDirName={autopf}\QuizApp
DefaultGroupName=QuizApp
; Icon cho file Setup.exe (Đảm bảo đường dẫn này đúng với project của bạn)
SetupIconFile=windows\runner\resources\app_icon.ico

; --- NÉN & ĐẦU RA ---
Compression=lzma
SolidCompression=yes
OutputDir=..\..\deploy\windows
; Tên file setup sẽ là: QuizApp_Setup_v0.1.0.exe
OutputBaseFilename=QuizApp_Setup_v{#MyAppVersion}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; 1. App Flutter (Dùng biến #MyAppExeName để đồng bộ)
Source: "build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; 2. Engine OCR Tesseract
Source: "windows\tesseract_bin\*"; DestDir: "{app}\tesseract_engine"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\QuizApp"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\QuizApp"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Tự động chạy app sau khi cài xong
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,QuizApp}"; Flags: nowait postinstall skipifsilent
