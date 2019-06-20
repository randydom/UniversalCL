﻿unit UCL.TUSymbolButton;

interface

uses
  UCL.Classes, UCL.SystemSettings, UCL.TUThemeManager, UCL.Utils,
  Winapi.Messages,
  System.Classes, System.Types,
  VCL.Controls, VCL.Graphics, VCL.ExtCtrls;

type
  TUCustomSymbolButton = class(TCustomPanel, IUThemeControl)
    const
      DefBackColor: TDefColor = (
        ($00E6E6E6, $00CFCFCF, $00B8B8B8, $00CCCCCC, $00CFCFCF),
        ($001F1F1F, $00353535, $004C4C4C, $00333333, $00353535));
      DefTextColor: TDefColor = (
        ($00000000, $00000000, $00000000, $00666666, $00000000),
        ($00FFFFFF, $00FFFFFF, $00FFFFFF, $00666666, $00FFFFFF));
      DefDetailColor: TDefColor = (
        ($00808080, $00808080, $00808080, $00808080, $00808080),
        ($00808080, $00808080, $00808080, $00808080, $00808080));

    private
      FThemeManager: TUThemeManager;

      FSymbolFont: TFont;
      FTextFont: TFont;
      FDetailFont: TFont;

      FButtonState: TUControlState;
      FEnabled: Boolean;
      FHitTest: Boolean;
      FOrientation: TUOrientation;
      FSymbolChar: string;
      FText: string;
      FTextOffset: Integer;
      FDetail: string;
      FDetailRightOffset: Integer;

      FShowIcon: Boolean;
      FShowDetail: Boolean;
      FTransparent: Boolean;
      FIsToggleButton: Boolean;
      FIsToggled: Boolean;

      //  Object setters
      procedure SetThemeManager(const Value: TUThemeManager);

      //  Value setters
      procedure SetButtonState(const Value: TUControlState);
      procedure SetEnabled(const Value: Boolean); reintroduce;
      procedure SetOrientation(const Value: TUOrientation);
      procedure SetSymbolChar(const Value: string);
      procedure SetText(const Value: string);
      procedure SetTextOffset(const Value: Integer);
      procedure SetDetail(const Value: string);
      procedure SetDetailRightOffset(const Value: Integer);
      procedure SetShowIcon(const Value: Boolean);
      procedure SetShowDetail(const Value: Boolean);
      procedure SetTransparent(const Value: Boolean);
      procedure SetIsToggled(const Value: Boolean);

      //  Messages
      procedure WM_LButtonDblClk(var Msg: TMessage); message WM_LBUTTONDBLCLK;
      procedure WM_LButtonDown(var Msg: TMessage); message WM_LBUTTONDOWN;
      procedure WM_LButtonUp(var Msg: TMessage); message WM_LBUTTONUP;
      procedure CM_MouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
      procedure CM_MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;

    protected
      procedure Paint; override;

    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy; reintroduce;
      procedure UpdateTheme;

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;

      property SymbolFont: TFont read FSymbolFont write FSymbolFont;
      property TextFont: TFont read FTextFont write FTextFont;
      property DetailFont: TFont read FDetailFont write FDetailFont;

      property ButtonState: TUControlState read FButtonState write SetButtonState default csNone;
      property Enabled: Boolean read FEnabled write SetEnabled default true;
      property HitTest: Boolean read FHitTest write FHitTest default true;
      property Orientation: TUOrientation read FOrientation write SetOrientation default oHorizontal;
      property SymbolChar: string read FSymbolChar write SetSymbolChar;
      property Text: string read FText write SetText;
      property TextOffset: Integer read FTextOffset write SetTextOffset default 40;
      property Detail: string read FDetail write SetDetail;
      property DetailRightOffset: Integer read FDetailRightOffset write SetDetailRightOffset default 10;
      property ShowIcon: Boolean read FShowIcon write SetShowIcon default true;
      property ShowDetail: Boolean read FShowDetail write SetShowDetail default true;
      property Transparent: Boolean read FTransparent write SetTransparent default false;
      property IsToggleButton: Boolean read FIsToggleButton write FIsToggleButton default false;
      property IsToggled: Boolean read FIsToggled write SetIsToggled default false;
  end;

  TUSymbolButton = class(TUCustomSymbolButton)
    published
      //  Common properties
      property Align;
      property Anchors;
      property Constraints;
      property DragCursor;
      property DragKind;
      property DragMode;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property Touch;
      property TabOrder;
      property TabStop;
      property Visible;

      //  Common events
      property OnClick;
      property OnContextPopup;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDock;
      property OnEndDrag;
      property OnGesture;
      property OnMouseActivate;
      property OnMouseDown;
      property OnMouseEnter;
      property OnMouseLeave;
      property OnMouseMove;
      property OnMouseUp;
      property OnStartDock;
      property OnStartDrag;
  end;

implementation

{ THEME }

procedure TUCustomSymbolButton.SetThemeManager(const Value: TUThemeManager);
begin
  if Value <> FThemeManager then
    begin
      //  Disconnect current ThemeManager
      if FThemeManager <> nil then
        FThemeManager.DisconnectControl(Self);

      //  Connect to new ThemeManager
      if Value <> nil then
        Value.ConnectControl(Self);

      FThemeManager := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.UpdateTheme;
begin
  Paint;
end;

{ VALUE SETTERS }

procedure TUCustomSymbolButton.SetButtonState(const Value: TUControlState);
begin
  if Value <> FButtonState then
    begin
      FButtonState := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetEnabled(const Value: Boolean);
begin
  if Value <> FEnabled then
    begin
      FEnabled := Value;
      if Value = false then
        FButtonState := csDisabled
      else
        FButtonState := csNone;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetOrientation(const Value: TUOrientation);
begin
  if Value <> FOrientation then
    begin
      FOrientation := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetSymbolChar(const Value: string);
begin
  if Value <> FSymbolChar then
    begin
      FSymbolChar := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetText(const Value: string);
begin
  if Value <> FText then
    begin
      FText := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetTextOffset(const Value: Integer);
begin
  if Value <> FTextOffset then
    begin
      FTextOffset := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetDetail(const Value: string);
begin
  if Value <> FDetail then
    begin
      FDetail := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetDetailRightOffset(const Value: Integer);
begin
  if Value <> FDetailRightOffset then
    begin
      FDetailRightOffset := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetShowIcon(const Value: Boolean);
begin
  if Value <> FShowIcon then
    begin
      FShowIcon := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetShowDetail(const Value: Boolean);
begin
  if Value <> FShowDetail then
    begin
      FShowDetail := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetTransparent(const Value: Boolean);
begin
  if Value <> FTransparent then
    begin
      FTransparent := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSymbolButton.SetIsToggled(const Value: Boolean);
begin
  if Value <> FIsToggled then
    begin
      FIsToggled := Value;
      UpdateTheme;
    end;
end;

{ MAIN CLASS }

constructor TUCustomSymbolButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FSymbolFont := TFont.Create;
  FSymbolFont.Name := 'Segoe MDL2 Assets';
  FSymbolFont.Size := 12;

  FTextFont := TFont.Create;
  FTextFont.Name := 'Segoe UI';
  FTextFont.Size := 10;

  FDetailFont := TFont.Create;
  FDetailFont.Name := 'Segoe UI';
  FDetailFont.Size := 10;

  FButtonState := csNone;
  FEnabled := true;
  FHitTest := true;
  FOrientation := oHorizontal;
  FSymbolChar := '';
  FText := 'Some text';
  FTextOffset := 40;
  FDetail := 'Detail';
  FDetailRightOffset := 10;
  FShowIcon := true;
  FShowDetail := true;
  FTransparent := false;
  FIsToggleButton := false;
  FIsToggled := false;

  Width := 250;
  Height := 40;
  TabStop := true;
  FullRepaint := false;

  //UpdateTheme;
end;

destructor TUCustomSymbolButton.Destroy;
begin
  FSymbolFont.Free;
  FTextFont.Free;
  FDetailFont.Free;
  inherited Destroy;
end;

{ CUSTOM METHODS }

procedure TUCustomSymbolButton.Paint;
var
  aTheme: TUTheme;
  IconX, IconY, IconW, IconH: Integer;
  TextX, TextY, TextW, TextH: Integer;
  DetailX, DetailY, DetailW, DetailH: Integer;

  BackColor, TextColor, DetailColor: TColor;
begin
  inherited;

  if ThemeManager = nil then
    aTheme := utLight
  else
    aTheme := ThemeManager.Theme;

  //  Transparent enabled
  if (ButtonState = csNone) and (Transparent = true) then
    begin
      ParentColor := true;
      BackColor := Color;
      TextColor := GetTextColorFromBackground(Color);
      DetailColor := DefDetailColor[aTheme, ButtonState];
    end

  //  Highlight enabled
  else if
    (ThemeManager <> nil)
    and ((IsToggleButton = true) and (IsToggled = true))
    and (ButtonState in [csNone, csHover, csFocused])
  then
    begin
      BackColor := ThemeManager.ActiveColor;
      TextColor := GetTextColorFromBackground(BackColor);
      DetailColor := clSilver;
    end

  //  Default colors
  else
    begin
      BackColor := DefBackColor[aTheme, ButtonState];
      TextColor := DefTextColor[aTheme, ButtonState];
      DetailColor := DefDetailColor[aTheme, ButtonState];
    end;

  //  Paint background
  Canvas.Brush.Color := BackColor;
  Canvas.FillRect(TRect.Create(0, 0, Width, Height));

  //  Paint icon
  if ShowIcon = true then
    begin
      Canvas.Font := SymbolFont;
      Canvas.Font.Color := TextColor;
      IconW := Canvas.TextWidth(SymbolChar);
      IconH := Canvas.TextHeight(SymbolChar);
      if Orientation = oHorizontal then
        begin
          IconX := (TextOffset - IconW) div 2;
          IconY := (Height - IconH) div 2;
        end
      else
        begin
          IconX := (Width - IconW) div 2;
          IconY := (TextOffset - IconH) div 2;
        end;
      Canvas.TextOut(IconX, IconY, SymbolChar);
    end;

  //  Paint text
  Canvas.Font := TextFont;
  Canvas.Font.Color := TextColor;
  TextW := Canvas.TextWidth(Text);
  TextH := Canvas.TextHeight(Text);
  if Orientation = oHorizontal then
    begin
      TextX := TextOffset;
      TextY := (Height - TextH) div 2;
    end
  else
    begin
      TextX := (Width - TextW) div 2;
      TextY := TextOffset;
    end;
  Canvas.TextOut(TextX, TextY, Text);

  //  Paint detail
  if ShowDetail = true then
    begin
      Canvas.Font := DetailFont;
      Canvas.Font.Color := DetailColor;
      DetailW := Canvas.TextWidth(Detail);
      DetailH := Canvas.TextHeight(Detail);
      if Orientation = oHorizontal then
        begin
          DetailX := Width - DetailRightOffset - DetailW;
          DetailY := (Height - DetailH) div 2;
        end
      else
        begin
          DetailX := (Width - DetailW) div 2;
          DetailY := Height - DetailRightOffset - DetailH;
        end;
      Canvas.TextOut(DetailX, DetailY, Detail);
    end;
end;

{ MESSAGES }

procedure TUCustomSymbolButton.WM_LButtonDblClk(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csPress;
      inherited;
    end;
end;

procedure TUCustomSymbolButton.WM_LButtonDown(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csPress;
      inherited;
    end;
end;

procedure TUCustomSymbolButton.WM_LButtonUp(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      if IsToggleButton = true then
        FIsToggled := not FIsToggled;
      ButtonState := csHover;
      inherited;
    end;
end;

procedure TUCustomSymbolButton.CM_MouseEnter(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csHover;
      inherited;
    end;
end;

procedure TUCustomSymbolButton.CM_MouseLeave(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csNone;
      inherited;
    end;
end;

end.
