object FormTelaLoad: TFormTelaLoad
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderIcons = []
  Caption = 'FormTelaLoad'
  ClientHeight = 665
  ClientWidth = 1202
  Color = clBtnFace
  TransparentColor = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    PanelStyle.Active = True
    TabOrder = 0
    Transparent = True
    ExplicitWidth = 628
    ExplicitHeight = 442
    DesignSize = (
      1202
      665)
    Height = 665
    Width = 1202
    object dxActivityIndicator1: TdxActivityIndicator
      Left = 259
      Top = 161
      Width = 622
      Height = 417
      Anchors = [akLeft, akTop, akRight, akBottom]
      PropertiesClassName = 'TdxActivityIndicatorElasticCircleProperties'
      Transparent = True
      ExplicitWidth = 638
      ExplicitHeight = 456
    end
    object cxLabel1: TcxLabel
      Left = 3
      Top = 3
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'CARREGANDO DADOS'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -37
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.WordWrap = True
      Transparent = True
      ExplicitWidth = 1212
      Height = 214
      Width = 1196
      AnchorX = 601
      AnchorY = 110
    end
  end
end
