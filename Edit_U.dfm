object frmImageEdit: TfrmImageEdit
  Left = 0
  Top = 0
  Caption = 'Image Editor'
  ClientHeight = 252
  ClientWidth = 662
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgDisplay: TImage
    Left = 0
    Top = 0
    Width = 662
    Height = 233
    Align = alClient
    Proportional = True
    Stretch = True
    OnMouseDown = imgDisplayMouseDown
    OnMouseMove = imgDisplayMouseMove
    OnMouseUp = imgDisplayMouseUp
    ExplicitLeft = 32
    ExplicitTop = 16
    ExplicitWidth = 361
  end
  object statInfo: TStatusBar
    Left = 0
    Top = 233
    Width = 662
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object mmMainMenu: TMainMenu
    Left = 608
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as...'
        OnClick = Saveas1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Close: TMenuItem
        Caption = 'Close'
        OnClick = CloseClick
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Edit: TMenuItem
      Caption = 'Edit'
      object RGBchannel: TMenuItem
        Caption = 'RGB Channels'
        OnClick = RGBchannelClick
      end
      object Brightness1: TMenuItem
        Caption = 'Brightness'
        OnClick = Brightness1Click
      end
      object InvertColours1: TMenuItem
        Caption = 'Invert Colours'
        OnClick = InvertColours1Click
      end
      object Contrast1: TMenuItem
        Caption = 'Contrast'
        OnClick = Contrast1Click
      end
      object Grayscale1: TMenuItem
        Caption = 'Grayscale'
        OnClick = Grayscale1Click
      end
    end
  end
  object tmrRepaint: TTimer
    Interval = 1
    OnTimer = tmrRepaintTimer
    Left = 608
    Top = 64
  end
end
