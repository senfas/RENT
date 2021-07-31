table 50108 "Auto Rent Demage"
{
    Caption = 'Auto Rent Demage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "Auto Rent Header";
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

            trigger OnValidate()
            begin
                CheckDate();
            end;

        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Demage Date", Description)
        {

        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNewLineNo();
    end;

    procedure CheckDate()
    var
        NeedToSelectDocumentNoErr: Label 'Firstly, you need to select Document No.';
        DateIsBeforeOrAfterReservadtionDateErr: Label 'Auto was reserved from %1 to %2.';
        AutoRentHeaderReservationDatesErr: Label 'You have to select reservation dates for Auto Rent Header with No.: %1';
        AutoRentHeader: Record "Auto Rent Header";
    begin
        if "Document No." = '' then
            Error(NeedToSelectDocumentNoErr);
        AutoRentHeader.SetRange("No.", "Document No.");
        if AutoRentHeader.FindSet() then begin
            if (AutoRentHeader."Start Date" = 0DT) OR (AutoRentHeader."End Date" = 0DT) then
                Error(AutoRentHeaderReservationDatesErr, Rec."Document No.");
            if not ((DT2DATE(AutoRentHeader."Start Date") <= "Demage Date") AND ("Demage Date" <= DT2DATE(AutoRentHeader."End Date"))) then
                Error(DateIsBeforeOrAfterReservadtionDateErr, AutoRentHeader."Start Date", AutoRentHeader."End Date");
        end;
    end;

    procedure GetNewLineNo(): Integer
    var
        AutoRentDemage: Record "Auto Rent Demage";
    begin
        AutoRentDemage.SetRange("Document No.", Rec."Document No.");
        if (AutoRentDemage.FindLast()) then
            exit(AutoRentDemage."Line No." + 1);
        exit(1);
    end;
}