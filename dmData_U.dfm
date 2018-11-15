object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 92
  object conDatabase: TADOConnection
    Left = 24
    Top = 8
  end
  object tblAllFiles: TADOTable
    Connection = conDatabase
    Left = 24
    Top = 56
  end
  object dsDataSource: TDataSource
    DataSet = tblAllFiles
    Left = 24
    Top = 104
  end
end
