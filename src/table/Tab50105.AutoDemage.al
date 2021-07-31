table 50105 "Auto Demage"
{
    Caption = 'Auto Demage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Car No."; Code[20])
        {
            Caption = 'Car No.';
            DataClassification = CustomerContent;
            TableRelation = Auto;

            trigger OnValidate()
            begin
                if "Line No." = 0 then
                    "Line No." := GetNewLineNo();
            end;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Demage Date"; Date)
        {
            Caption = 'Demage Date';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(30; Status; Enum "Status For Demage")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Car No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Car No.", "Demage Date")
        {

        }
    }

    procedure GetNewLineNo(): Integer
    var
        AutoDemage: Record "Auto Demage";
    begin
        AutoDemage.SetRange("Car No.", Rec."Car No.");
        if (AutoDemage.FindLast()) then
            exit(AutoDemage."Line No." + 1);
        exit(1);
    end;
}