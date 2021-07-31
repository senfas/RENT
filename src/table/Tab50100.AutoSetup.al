table 50100 "Auto Setup"
{
    Caption = 'Auto Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Auto Nos."; Code[20])
        {
            Caption = 'Auto Nos.';
            TableRelation = "No. Series";
        }
        field(20; "Auto Rent Header Nos."; Code[20])
        {
            Caption = 'Auto Rent Header Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Transfer Nos."; Code[20])
        {
            Caption = 'Transfer Nos.';
            TableRelation = "No. Series";
        }
        field(40; "Items warehouse location code"; Code[10])
        {
            Caption = '"Items warehouse location code"';
            TableRelation = Location;
        }
    }


    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        SetDefaultValues();
    end;

    procedure InsertIfNotExist()
    begin
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    procedure SetDefaultValues()
    var
        AutoNosManagment: Codeunit "Auto Nos Management";
        AutoNosCodeLbl: Label 'AUTO';
        AutoNosDescriptionLbl: Label 'Auto Nos';
        AutoNosFirstNoLbl: Label 'AUTO0001';
        RentCardNosCodeLbl: Label 'AUTO RENT';
        RentCardNosDescriptionLbl: Label 'Auto Rent Header Nos';
        RentCardNosFirstNoLbl: Label 'RENT0001';
        TransferNosCodeLbl: Label 'TRANSFER';
        TransferNosDescription: Label 'Item Transfer Nos';
        TransferNosFirstNoLbl: Label 'TRANS00001';
    begin
        if "Auto Nos." = '' then
            "Auto Nos." := AutoNosManagment.NewNoSeries(AutoNosCodeLbl, AutoNosDescriptionLbl, AutoNosFirstNoLbl);
        if "Auto Rent Header Nos." = '' then
            "Auto Rent Header Nos." := AutoNosManagment.NewNoSeries(RentCardNosCodeLbl, RentCardNosDescriptionLbl, RentCardNosFirstNoLbl);
        if "Transfer Nos." = '' then
            "Transfer Nos." := AutoNosManagment.NewNoSeries(TransferNosCodeLbl, TransferNosDescription, TransferNosFirstNoLbl);
    end;
}