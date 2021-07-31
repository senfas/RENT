table 50107 "Auto Rent Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Type"; Enum "Auto Rent Line Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestHeaderStatusOpenAndMain();

                "No." := '';
                Description := '';
                "Base Unit of Measure" := '';
                Amount := 0;
                "Total Amount" := 0;
            end;
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No';
            DataClassification = CustomerContent;
            TableRelation =
            if (Type = const(Item)) Item where("Item Category Code" = const('RENT')) else
            if (Type = const(Resource)) Resource where("Resource Group No." = const('RENT'));

            trigger OnValidate()
            var
                Resource: Record Resource;
                Item: Record Item;
            begin
                TestHeaderStatusOpenAndMain();

                if (Type = Type::Item) then
                    if Item.Get(Rec."No.") then begin
                        Rec.Description := Item.Description;
                        Amount := Item."Unit Price";
                        "Base Unit of Measure" := Item."Base Unit of Measure";
                    end;

                if Type = Type::Resource then
                    if Resource.Get(Rec."No.") then begin
                        Rec.Description := Resource.Name;
                        Amount := Resource."Unit Price";
                        "Base Unit of Measure" := Resource."Base Unit of Measure";
                    end;

                if Quantity <> 0 then
                    "Total Amount" := Quantity * Amount;
            end;
        }
        field(30; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Base Unit of Measure"; Code[20])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestHeaderStatusOpenAndMain();

                if Amount <> 0 then
                    "Total Amount" := Quantity * Amount;
            end;
        }
        field(50; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                AutoRentHeader: Record "Auto Rent Header";
            begin
                AutoRentHeader.Get("Document No.");
                if AutoRentHeader.Status = AutoRentHeader.Status::Released then
                    TestHeaderStatusOpenAndMain();

                if Quantity <> 0 then
                    "Total Amount" := Quantity * Amount;
            end;
        }
        field(60; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(80; Main; Boolean)
        {
            Caption = 'Main Line';
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        MainDeleteErr: Label 'You can not delete this line';
        AutoRentHeader: Record "Auto Rent Header";
        HeaderStatusReleasedDeleteErr: Label 'You Can not delete lines while status is released';
    begin
        if Rec.Main then
            Error(MainDeleteErr);
        if AutoRentHeader.Get(Rec."Document No.") then
            if AutoRentHeader.Status = AutoRentHeader.Status::Released then
                Error(HeaderStatusReleasedDeleteErr);
    end;

    procedure TestHeaderStatusOpenAndMain()
    var
        AutoRentHeader: Record "Auto Rent Header";
        HeaderStatusReleasedErr: Label 'You Can not modify lines while status is released';
    begin
        TestField(Main, false);

        AutoRentHeader.Get("Document No.");
        if AutoRentHeader.Status = AutoRentHeader.Status::Released then
            Error(HeaderStatusReleasedErr);
    end;
}