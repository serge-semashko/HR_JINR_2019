object mainform: Tmainform
  Left = 695
  Top = 284
  Width = 339
  Height = 491
  Caption = 'Export to  EVM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 321
    Height = 402
    Align = alClient
    TabOrder = 0
    object SheetList: TListBox
      Left = 1
      Top = 1
      Width = 319
      Height = 400
      Align = alClient
      ItemHeight = 16
      MultiSelect = True
      TabOrder = 0
      OnDblClick = SaveAs1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 402
    Width = 321
    Height = 19
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 392
    Top = 96
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Export'
        OnClick = SaveAs1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
      end
    end
  end
  object od: TOpenDialog
    Filter = 'xls|*.xl*'
    Left = 64
    Top = 8
  end
end
