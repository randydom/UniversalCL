unit UCL.Classes;

interface

uses
  System.Classes,
  VCL.Graphics;

type
  TUTheme = (utLight, utDark);

  TUOrientation = (oHorizontal, oVertical);

  TUDirection = (dLeft, dTop, dRight, dBottom);

  TUControlState = (csNone, csHover, csPress, csDisabled, csFocused);

  TUImageKind = (ikFontIcon, ikImage);

  TDefColor = array [TUTheme, TUControlState] of TColor;

  AccentPolicy = packed record
    AccentState: Integer;
    AccentFlags: Integer;
    GradientColor: Integer;
    AnimationId: Integer;
  end;

  WindowCompositionAttributeData = packed record
    Attribute: Cardinal;
    Data: Pointer;
    SizeOfData: Integer;
  end;

  TQuadColor = packed record
    case Boolean of
      True : (Blue, Green, Red, Alpha : Byte);
      False : (Quad : Cardinal);
  end;

  PQuadColor = ^TQuadColor;
  PPQuadColor = ^PQuadColor;

  TControlStateColors = class(TPersistent)
    private
      FNone: TColor;
      FHover: TColor;
      FPress: TColor;
      FDisabled: TColor;
      FFocused: TColor;

      FOnChange: TNotifyEvent;

      procedure SetStateColor(const Index: Integer; const Value: TColor);

    protected 
      procedure Changed;

    public
      constructor Create(aNone, aHover, aPress, aDisabled, aFocused: TColor); overload;
      function GetStateColor(const State: TUControlState): TColor;

    published
      property None: TColor index 0 read FNone write SetStateColor default $000000;
      property Hover: TColor index 1 read FHover write SetStateColor default $000000;
      property Press: TColor index 2 read FPress write SetStateColor default $000000;
      property Disabled: TColor index 3 read FDisabled write SetStateColor default $000000;
      property Focused: TColor index 4 read FFocused write SetStateColor default $000000;

      property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TControlStateColors }

procedure TControlStateColors.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TControlStateColors.Create(aNone, aHover, aPress, aDisabled, aFocused: TColor);
begin
  inherited Create;

  FNone := aNone;
  FHover := aHover;
  FPress := aPress;
  FDisabled := aDisabled;
  FFocused := aFocused;
end;

function TControlStateColors.GetStateColor(const State: TUControlState): TColor;
begin
  case State of
    csNone:
      Result := None;
    csHover:
      Result := Hover;
    csPress:
      Result := Press;
    csDisabled:
      Result := Disabled;
    csFocused:
      Result := Focused;
    else
      Result := None;
  end;
end;

procedure TControlStateColors.SetStateColor(const Index: Integer; const Value: TColor);
begin
  case Index of
    0:  
      if Value <> FNone then
        begin
          FNone := Value;
          Changed;
        end;    
    1:
      if Value <> FHover then
        begin
          FHover := Value;
          Changed;
        end;
    2:
      if Value <> FPress then
        begin
          FPress := Value;
          Changed;
        end;
    3:
      if Value <> FDisabled then
        begin
          FDisabled := Value;
          Changed;
        end;
    4:
      if Value <> FFocused then
        begin
          FFocused := Value;
          Changed;
        end;
  end;
end;

end.
