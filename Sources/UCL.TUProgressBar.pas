unit UCL.TUProgressBar;

interface

uses
  UCL.Classes, UCL.TUThemeManager, UCL.Utils,
  UCL.IntAnimation,
  System.Classes, System.Types,
  Winapi.Messages,
  VCL.Controls, VCL.Graphics;

type
  TUCustomProgressBar = class(TCustomControl, IUThemeComponent)
    private
      var FillColor: TColor;
      var BackColor: TColor;
      var FillRect: TRect;
      var BackRect: TRect;

      FThemeManager: TUThemeManager;

      FValue: Integer;
      FOrientation: TUOrientation;
      FCustomFillColor: TColor;
      FCustomBackColor: TColor;

      //  Internal
      procedure UpdateColors;
      procedure UpdateRects;

      //  Setters
      procedure SetThemeManager(const Value: TUThemeManager);
      procedure SetValue(const Value: Integer);
      procedure SetOrientation(const Value: TUOrientation);

    protected
      procedure Paint; override;
      procedure Resize; override;
      procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;

    public
      constructor Create(aOnwer: TComponent); override;
      procedure UpdateTheme;

      procedure GoToValue(Value: Integer);

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;

      property Value: Integer read FValue write SetValue;
      property Orientation: TUOrientation read FOrientation write SetOrientation;
      property CustomFillColor: TColor read FCustomFillColor write FCustomFillColor;
      property CustomBackColor: TColor read FCustomBackColor write FCustomBackColor;
  end;

  TUProgressBar = class(TUCustomProgressBar)
    published
      property Align;
      property Anchors;
      property AutoSize;
      property BiDiMode;
      property Caption;
      property Color;
      property Constraints;
      property DragCursor;
      property DragKind;
      property DragMode;
      property Enabled;
      property Font;
      property ParentBiDiMode;
      property ParentColor;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property Touch;
      property Visible;
      property StyleElements;

      property OnCanResize;
      property OnClick;
      property OnConstrainedResize;
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
      property OnResize;
      property OnStartDock;
      property OnStartDrag;
  end;

implementation

{ TUCustomProgressBar }

//  THEME

procedure TUCustomProgressBar.SetThemeManager(const Value: TUThemeManager);
begin
  if Value <> FThemeManager then
    begin
      if FThemeManager <> nil then
        FThemeManager.Disconnect(Self);

      if Value <> nil then
        Value.Connect(Self);

      FThemeManager := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomProgressBar.UpdateTheme;
begin
  UpdateColors;
  UpdateRects;
  Repaint;
end;

//  INTERNAL

procedure TUCustomProgressBar.UpdateColors;
begin
  //  Background & fill color
  if ThemeManager = nil then
    begin
      BackColor := FCustomBackColor;
      FillColor := FCustomFillColor;
    end
  else if ThemeManager.Theme = utLight then
    begin
      BackColor := $CCCCCC;
      FillColor := ThemeManager.AccentColor;
    end
  else
    begin
      BackColor := $333333;
      FillColor := ThemeManager.AccentColor;
    end;
end;

procedure TUCustomProgressBar.UpdateRects;
begin
  //  Background & fill area
  if Orientation = oHorizontal then
    begin
      FillRect := Rect(0, 0, Round(Value / 100 * Width), Height);
      BackRect := Rect(FillRect.Right, 0, Width, Height);
    end
  else
    begin
      BackRect := Rect(0, 0, Width, Round(Value / 100 * Height));
      FillRect := Rect(0, BackRect.Bottom, Width, Height);
    end;
end;

//  SETTERS

procedure TUCustomProgressBar.SetValue(const Value: Integer);
begin
  if FValue <> Value then
    begin
      FValue := Value;
      UpdateRects;
      Repaint;
    end;
end;

procedure TUCustomProgressBar.SetOrientation(const Value: TUOrientation);
begin
  if FOrientation <> Value then
    begin
      FOrientation := Value;
      UpdateRects;
      Repaint;
    end;
end;

//  MAIN CLASS

constructor TUCustomProgressBar.Create(aOnwer: TComponent);
begin
  inherited Create(aOnwer);

  FValue := 0;
  FCustomFillColor := $25B006;
  FCustomBackColor := $E6E6E6;

  Height := 5;
  Width := 100;

  UpdateColors;
  UpdateRects;
end;

procedure TUCustomProgressBar.GoToValue(Value: Integer);
var
  Ani: TIntAni;
begin
  if not Enabled then exit;

  Ani := TIntAni.Create(true, akOut, afkQuartic, FValue, Value - FValue,
    procedure (Value: Integer)
    begin
      Self.Value := Value;
    end);
  Ani.Step := 25;
  Ani.Duration := 250;
  Ani.Start;
end;

//  CUSTOM METHODS

procedure TUCustomProgressBar.Paint;
begin
  inherited;

  //  Paint background
  Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BackColor, 255);
  Canvas.FillRect(BackRect);

  //  Paint Fillround
  Canvas.Brush.Handle := CreateSolidBrushWithAlpha(FillColor, 255);
  Canvas.FillRect(FillRect);
end;

procedure TUCustomProgressBar.Resize;
begin
  inherited;
  UpdateRects;
end;

procedure TUCustomProgressBar.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  inherited;
  UpdateRects;
end;

end.
