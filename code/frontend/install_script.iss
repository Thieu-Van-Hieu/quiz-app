[Setup]
; AppId duy nhất để Windows nhận diện bản cập nhật
AppId={{D3F7B2A1-0E34-4A8E-9C8F-123456789ABC}}
AppName=QuizApp
AppVersion=0.1.0
AppPublisher=Mr.NoBody

; --- CONFIG HIỂN THỊ TRONG CONTROL PANEL ---
; Ép tên hiển thị đúng ý đồ, không tự thêm chữ "version"
UninstallDisplayName=QuizApp
; Lấy icon từ chính file exe sau khi cài để hiện trong Add/Remove Programs
UninstallDisplayIcon={app}\frontend.exe

; --- THIẾT LẬP THƯ MỤC & ICON ---
DefaultDirName={autopf}\QuizApp
DefaultGroupName=Quiz App
; Icon cho file Setup.exe
SetupIconFile=windows\runner\resources\app_icon.ico

; --- NÉN & ĐẦU RA ---
Compression=lzma
SolidCompression=yes
OutputDir=..\..\deploy\windows
; Tên file setup sẽ là: QuizApp_Setup_v1.0.0.exe
OutputBaseFilename=QuizApp_Setup_v{#SetupSetting("AppVersion")}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; 1. App Flutter (Frontend)
; Chú ý: đảm bảo file trong Release đúng tên là frontend.exe
Source: "build\windows\x64\runner\Release\frontend.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; 2. Engine OCR Tesseract (Các file DLL và EXE bạn đã copy bằng Copy-Item)
Source: "windows\tesseract_bin\*"; DestDir: "{app}\tesseract_engine"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Quiz App"; Filename: "{app}\frontend.exe"
Name: "{autodesktop}\Quiz App"; Filename: "{app}\frontend.exe"; Tasks: desktopicon

[Run]
; Tự động chạy app sau khi cài xong
Filename: "{app}\frontend.exe"; Description: "{cm:LaunchProgram,Quiz App}"; Flags: nowait postinstall skipifsilent