unit graham;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Point = record
    x, y: integer;
  end;
  Point_arr = record
    p: array[0..10000] of point;
    count: integer;
  end;
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    PaintBox1: TPaintBox;
    Button2: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Button3: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Points, stack: point_arr;
  //minx: integer;
                                                    //AB * BC
implementation

{$R *.dfm}

function rotate(a, b, c: point): integer;
begin
  rotate := (b.x - a.x) * (c.y - b.y) - (b.y - a.y) * (c.x - b.x);
end;

procedure swap(var a, b: point);
var
  c: point;
begin
  c.x := a.x;
  c.y := a.y;
  a.x := b.x;
  a.y := b.y;
  b.x := c.x;
  b.y := c.y;
end;

procedure quicksort(left, right: integer);
var
  i, j, mid: integer;
  u: point;

begin
  i := left;
  j := right;
  mid := random(right - left + 1) + left;
  u := points.p[mid];
  while (i <= j) do begin
    while (rotate(u, points.p[1], points.p[i]) < 0) do
      inc(i);
    while (rotate(u, points.p[1], points.p[j]) > 0) do
      dec(j);
    if (i <= j) then begin
      swap(points.p[i], points.p[j]);
      inc(i);
      dec(j);
    end;
  end;
  if (i < right) then
    quicksort(i, right);
  if (left < j) then
    quicksort(left, j);
end;



procedure add_point(x, y: integer);
begin
  form1.PaintBox1.Canvas.Pen.Color:= clGreen;
  form1.PaintBox1.Canvas.Pen.Width:= 7;
  //form1.PaintBox1.Canvas.MoveTo(X,Y); // если нажата левая кнопка то перевидаем добавим точку
  form1.PaintBox1.Canvas.Ellipse(x - 1, y - 1, x, y);
  inc(points.count);
  form1.label1.Caption := 'Колличество точек: ' + inttostr(points.count);
  points.p[points.count].x := x;
  points.p[points.count].y := y;
  form1.memo1.Lines.Add('(' + inttostr(x) + ' , ' + inttostr(y) + ')');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  halt(0);
end;

procedure grahamscan();
var
  i: integer;
begin
  //minx := maxint;
  for i := 1 to points.count do begin
    if (points.p[1].x > points.p[i].x) then
      swap(points.p[1], points.p[i]);
  end;
  quicksort(2, points.count);
  form1.PaintBox1.Canvas.Pen.Color:= clAqua;
  form1.PaintBox1.Canvas.Pen.Width:= 2;
  stack.count := 2;
  form1.PaintBox1.Canvas.MoveTo(points.p[1].x, points.p[1].y);
  stack.p[1].x := points.p[1].x;
  stack.p[1].y := points.p[1].y;
  stack.p[2].x := points.p[2].x;
  stack.p[2].y := points.p[2].y;
  //form1.PaintBox1.Canvas.LineTo(points.p[1].x, points.p[2].y);
  for i := 2 to points.count do begin
    while (rotate(stack.p[stack.count - 1], stack.p[stack.count], points.p[i]) > 0) do
      dec(stack.count);
    inc(stack.count);
    stack.p[stack.count] := points.p[i];
  end;
  for i := 2 to stack.count do begin
    form1.PaintBox1.Canvas.LineTo(stack.p[i].x, stack.p[i].y);
    form1.PaintBox1.Canvas.MoveTo(stack.p[i].x, stack.p[i].y);
  end;
    form1.PaintBox1.Canvas.LineTo(stack.p[1].x, stack.p[1].y);
  form1.Memo1.Lines.add(inttostr(stack.count));
end;



procedure box_reload();
var
  a: TRect;
begin
  //form1.PaintBox1.Canvas.Pen.Width:=5;
  a.top := 0;
  a.Bottom := form1.PaintBox1.Height;
  a.left := 0;
  a.Right := form1.PaintBox1.Width;
  form1.PaintBox1.Refresh;
  points.count := 0;
  form1.Memo1.Clear();
  form1.label1.Caption := 'Колличество точек: ' + inttostr(points.count);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //paintbox1.Canvas.brush.Color := clBackground;
  randomize();
  form1.paintbox1.Canvas.brush.Color := $00332F00;
end;

procedure TForm1.Button2Click(Sender: TObject); // Очищение поля
begin
  box_reload();
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; // задание точек мышкой
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBox1.Canvas.Pen.Width:= 4; //Задаем размер карандаша
  PaintBox1.Canvas.Pen.Color:= clGreen; //Цвет
  if button = mbLeft then begin
    add_point(x, y);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject); // случайное заполнение точками
var
  i: integer;
begin
  if edit2.Text <> '' then begin
    for i := 1 to strtoint(edit2.Text) do
      add_point(random(paintbox1.Width - 50) + 25, random(paintbox1.Height - 50) + 25);
    edit2.Text := '';
  end;
end;

procedure TForm1.Edit2Change(Sender: TObject);// корректное заполнение колличества случайных точек(только цифры
var
  s: string;
  i: integer;
begin
  s := edit2.Text;
  for i := 1 to length(s) do begin
    if not(s[i] in ['0'..'9']) then begin
      delete(s, i, 1);
    end;
  end;
  edit2.Text := s;
  edit2.SelStart := length(s);
  edit2.SelLength := 0;
end;

procedure TForm1.Button4Click(Sender: TObject);   // Алгоритм Грэхема
begin
  grahamscan();

end;

end.
