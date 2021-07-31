table 50103 "Auto"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(20; Mark; Code[20])
        {
            Caption = 'Mark';
            DataClassification = CustomerContent;
            TableRelation = "Auto Mark";

            trigger OnValidate()
            begin
                if Rec.Mark <> xRec.Mark then begin
                    Model := '';
                    Name := '';
                end;
            end;
        }
        field(30; Model; Code[20])
        {
            Caption = 'Model';
            DataClassification = CustomerContent;
            TableRelation = "Auto Model".Code where("Mark Code" = field(Mark));

            trigger OnValidate()
            begin
                if (Mark <> '') AND (Name = '') AND (Rec.Model <> xRec.Model) then
                    Name := Format(Mark) + ' ' + Format(Model);
            end;
        }
        field(40; "First Registration Year"; Integer)
        {
            Caption = 'First Registration Year';
            DataClassification = CustomerContent;
            MinValue = 1900;
        }
        field(50; "Insurance to"; Date)
        {
            Caption = 'Insurance To';
            DataClassification = CustomerContent;
        }
        field(60; "Technical Inspection"; Date)
        {
            Caption = 'Technical Inspection';
            DataClassification = CustomerContent;
        }
        field(70; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(80; "Rent Service"; Code[20])
        {
            Caption = 'Rent Service';
            DataClassification = CustomerContent;
            TableRelation = Resource where("Resource Group No." = const('CARRENT'));
        }
        field(90; "Rent Price"; Decimal)
        {
            Caption = 'Rent Price';
            FieldClass = FlowField;
            TableRelation = Resource;
            CalcFormula = lookup(Resource."Unit Price" where("No." = field("Rent Service")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then
            "No." := GetNewAutoNoFromNosSeries();
    end;

    procedure GetNewAutoNoFromNosSeries(): Code[20]
    var
        AutoSetup: Record "Auto Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        AutoSetup.Get();
        AutoSetup.TestField("Auto Nos.");
        exit(NoSeriesManagement.GetNextNo(AutoSetup."Auto Nos.", WorkDate(), true));
    end;

}