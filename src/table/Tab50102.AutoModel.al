table 50102 "Auto Model"
{
    Caption = 'Auto Model';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Mark Code"; Code[20])
        {
            Caption = 'Mark Code';
            DataClassification = CustomerContent;
            TableRelation = "Auto Mark";
        }
        field(2; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Mark Code", Code)
        {
            Clustered = true;
        }
    }
}