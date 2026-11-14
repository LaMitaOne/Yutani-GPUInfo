unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Yutani.GPUInfo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function RunDetectionWithTempContext: string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.RunDetectionWithTempContext: string;
var
  DummyWnd: HWND;
  DC: HDC;
  PFD: TPixelFormatDescriptor;
  PF: Integer;
  GLRC: HGLRC;
  Caps: TGPUCapabilities;
begin
  DummyWnd := CreateWindowEx(0, 'STATIC', 'GPUCheckDummy', WS_POPUP,
    0, 0, 16, 16, 0, 0, HInstance, nil);
  if DummyWnd = 0 then
    Exit('Fehler: Dummy-Fenster konnte nicht erstellt werden.');

  DC := GetDC(DummyWnd);
  GLRC := 0;
  try
    FillChar(PFD, SizeOf(PFD), 0);
    PFD.nSize := SizeOf(PFD);
    PFD.nVersion := 1;
    PFD.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
    PFD.iPixelType := PFD_TYPE_RGBA;
    PFD.cColorBits := 32;

    PF := ChoosePixelFormat(DC, @PFD);
    if (PF = 0) or not SetPixelFormat(DC, PF, @PFD) then
      Exit('Fehler: OpenGL PixelFormat konnte nicht gesetzt werden.');

    GLRC := wglCreateContext(DC);
    if GLRC = 0 then
      Exit('Fehler: wglCreateContext fehlgeschlagen.');

    wglMakeCurrent(DC, GLRC);
    try
      Caps := DetectGPUCapabilities(True);
      Result := FormatGPUReport(Caps);
    finally
      wglMakeCurrent(0, 0);
    end;
  finally
    if GLRC <> 0 then
      wglDeleteContext(GLRC);
    if DC <> 0 then
      ReleaseDC(DummyWnd, DC);
    DestroyWindow(DummyWnd);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'Yutani GPU Hardware Detector';
  Button1.Caption := 'Detect GPU';
  Memo1.Font.Name := 'Consolas';
  Memo1.Font.Size := 10;
  Memo1.ScrollBars := ssBoth;
  Memo1.Clear;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Enabled := False;
  Memo1.Lines.Text := 'Pruefe GPU Hardware & Compute-Speed...';
  Application.ProcessMessages;
  try
    Memo1.Lines.Text := RunDetectionWithTempContext;
  finally
    Button1.Enabled := True;
  end;
end;

end.

