table 50104 "Auto Reservation"
{
    Caption = 'Auto Reservation';
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
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(20; "Reserved From"; DateTime)
        {
            Caption = 'Reserved From';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CarNoErrorLbl: Label 'First you need to select %1';
            begin
                if "Car No." = '' then
                    Error(CarNoErrorLbl, FieldCaption("Car No."))
                else
                    if "Reserved To" <> 0DT then
                        CheckReservationDates();
            end;
        }
        field(21; "Reserved To"; DateTime)
        {
            Caption = 'Reserved To';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CarNoErrorLbl: Label 'First you need to select %1';
            begin
                if "Car No." = '' then
                    Error(CarNoErrorLbl, FieldCaption("Car No."))
                else
                    if "Reserved From" <> 0DT then
                        CheckReservationDates();
            end;
        }
    }

    keys
    {
        key(Key1; "Car No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Car No.", "Reserved From")
        {

        }
    }
    procedure CheckReservationDates()
    var
        ReservedFromAfterReservedToErrorLbl: Label 'Reserved to %1 can not be before Reserved from %2';
        AutoReservation: Record "Auto Reservation";
        DatesDublicatesErrorLbl: Label 'In %1 - %2 car with No. %3 is already reserved';
    begin
        // Checking ReservedFrom is before ReservedTi
        if not ("Reserved From" < "Reserved To") then
            Error(ReservedFromAfterReservedToErrorLbl, "Reserved To", "Reserved From");

        //Checking Reservation dublicates
        AutoReservation.SetRange("Car No.", Rec."Car No.");
        if AutoReservation.FindSet() then
            repeat
                // Checking if new DateTime is not in the older DateTime intervals.
                if (((AutoReservation."Reserved From" <= Rec."Reserved From") AND (Rec."Reserved From" <= AutoReservation."Reserved To")
                OR (AutoReservation."Reserved From" <= Rec."Reserved To") AND (Rec."Reserved To" <= AutoReservation."Reserved To"))
                // Checking if old DateTime is not in the new DateTime interval.
                OR (AutoReservation."Reserved From" >= Rec."Reserved From") AND (AutoReservation."Reserved To" <= Rec."Reserved To"))
                // Checking, that is not the same record.
                AND (AutoReservation."Line No." <> Rec."Line No.") then
                    Error(DatesDublicatesErrorLbl, Rec."Reserved From", Rec."Reserved To", Rec."Car No.");
            until AutoReservation.Next() = 0;

    end;

    procedure GetNewLineNo(): Integer
    var
        AutoReservation: Record "Auto Reservation";
    begin
        AutoReservation.SetRange("Car No.", Rec."Car No.");
        if (AutoReservation.FindLast()) then
            exit(AutoReservation."Line No." + 1);
        exit(1);
    end;
}