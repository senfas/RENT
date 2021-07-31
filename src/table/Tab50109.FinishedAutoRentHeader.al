table 50109 "Finished Auto Rent Header"
{
    Caption = 'Finished Auto Rent Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Driver License"; Media)
        {
            Caption = 'Driver License';
            DataClassification = CustomerContent;
            ExtendedDatatype = Person;
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Car No."; Code[20])
        {
            Caption = 'Car No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "Start Date"; DateTime)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(51; "End Date"; DateTime)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(52; "Duration in days"; Integer)
        {
            Caption = 'Duration in Days';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Start Date")
        {

        }
    }
}