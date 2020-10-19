object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1058#1077#1082#1091#1097#1077#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1041#1044
  ClientHeight = 499
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 65
    Width = 774
    Height = 434
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Visible = False
    Columns = <
      item
        Expanded = False
        FieldName = 'symbol1'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'symbol2'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'symbol'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'high'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'low'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'volume'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'quoteVolume'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'percentChange'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'updatedAt'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 65
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 14
      Width = 75
      Height = 13
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1081': 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 631
      Top = 10
      Width = 129
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1086#1079#1080#1094#1080#1102
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 496
      Top = 10
      Width = 129
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1086#1079#1080#1094#1080#1102
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 65
    Width = 774
    Height = 434
    Align = alClient
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    object cxGrid1DBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.ShowCheckBoxesDynamically = True
      OptionsView.Indicator = True
      Bands = <
        item
        end>
      object cxGrid1DBBandedTableView1symbol1: TcxGridDBBandedColumn
        DataBinding.FieldName = 'symbol1'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1symbol2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'symbol2'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1high: TcxGridDBBandedColumn
        DataBinding.FieldName = 'high'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1low: TcxGridDBBandedColumn
        DataBinding.FieldName = 'low'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1volume: TcxGridDBBandedColumn
        DataBinding.FieldName = 'volume'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1quoteVolume: TcxGridDBBandedColumn
        DataBinding.FieldName = 'quoteVolume'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1percentChange: TcxGridDBBandedColumn
        DataBinding.FieldName = 'percentChange'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1updatedAt: TcxGridDBBandedColumn
        DataBinding.FieldName = 'updatedAt'
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBBandedTableView1
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 176
    Top = 8
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = main_table
    Left = 240
    Top = 8
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 304
    Top = 8
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    Left = 360
    Top = 8
  end
  object main_table: TFDQuery
    IndexFieldNames = 'symbol'
    Connection = FDConnection1
    SQL.Strings = (
      'select '
      'SUBSTR(cast(symbol as char(50)), 1, '
      'INSTR( cast(symbol as char(50)),'#39'-'#39')-1'
      ') '
      'AS symbol1,'
      ''
      'SUBSTR(cast(symbol as char(50)),  '
      'INSTR( cast(symbol as char(50)),'#39'-'#39')+1,40'
      ') '
      'AS symbol2,'
      'cast(symbol as char(50)) as symbol,'
      'cast(high as char(50)) as high,'
      'cast(low as char(50)) as low,'
      'cast(volume as char(50)) as volume,'
      'cast(quoteVolume as char(50)) as quoteVolume,'
      'cast(percentChange as double) as percentChange,'
      'cast(updatedAt as char(50)) as updatedAt'
      ' from main')
    Left = 424
    Top = 8
  end
  object tmain: TFDTable
    IndexFieldNames = 'symbol'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'main'
    TableName = 'main'
    Left = 480
    Top = 8
    object tmainsymbol: TWideMemoField
      FieldName = 'symbol'
      Origin = 'symbol'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      BlobType = ftWideMemo
    end
    object tmainhigh: TWideMemoField
      FieldName = 'high'
      Origin = 'high'
      BlobType = ftWideMemo
    end
    object tmainlow: TWideMemoField
      FieldName = 'low'
      Origin = 'low'
      BlobType = ftWideMemo
    end
    object tmainvolume: TWideMemoField
      FieldName = 'volume'
      Origin = 'volume'
      BlobType = ftWideMemo
    end
    object tmainquoteVolume: TWideMemoField
      FieldName = 'quoteVolume'
      Origin = 'quoteVolume'
      BlobType = ftWideMemo
    end
    object tmainpercentChange: TWideMemoField
      FieldName = 'percentChange'
      Origin = 'percentChange'
      BlobType = ftWideMemo
    end
    object tmainupdatedAt: TWideMemoField
      FieldName = 'updatedAt'
      Origin = 'updatedAt'
      BlobType = ftWideMemo
    end
  end
end
