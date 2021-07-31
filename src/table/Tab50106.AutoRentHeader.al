table 50106 "Auto Rent Header"
{
    Caption = 'Auto Rent Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                CheckIsCustomerBlocked();
                CheckCustomerDebts();

                if ("End Date" <> 0DT) AND ("Start Date" <> 0DT) AND ("Car No." <> '') then begin
                    CheckReservation();
                    CalculateDurationDays();
                    InsertNewLine();
                    CheckInvoiceDublicate();
                    CheckFinishedInvoiceDublicate();
                end;
            end;

        }
        field(20; "Driver License"; Media)
        {
            Caption = 'Driver License';
            DataClassification = CustomerContent;
            ExtendedDatatype = Person;

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(40; "Car No."; Code[20])
        {
            Caption = 'Car No.';
            DataClassification = CustomerContent;
            TableRelation = Auto;

            trigger OnValidate()
            begin
                if ("End Date" <> 0DT) AND ("Start Date" <> 0DT) AND ("Customer No." <> '') then begin
                    CheckReservation();
                    CalculateDurationDays();
                    InsertNewLine();
                    CheckInvoiceDublicate();
                    CheckFinishedInvoiceDublicate();

                end;
            end;
        }
        field(50; "Start Date"; DateTime)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("End Date" <> 0DT) AND ("Car No." <> '') AND ("Customer No." <> '') then begin
                    CheckReservation();
                    CalculateDurationDays();
                    InsertNewLine();
                    CheckInvoiceDublicate();
                    CheckFinishedInvoiceDublicate();

                end;
            end;
        }
        field(51; "End Date"; DateTime)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("Start Date" <> 0DT) AND ("Car No." <> '') AND ("Customer No." <> '') then begin
                    CheckReservation();
                    CalculateDurationDays();
                    InsertNewLine();
                    CheckInvoiceDublicate();
                    CheckFinishedInvoiceDublicate();
                end;
            end;
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
            FieldClass = FlowField;
            CalcFormula = sum("Auto Rent Line"."Total Amount" where("Document No." = field("No.")));
        }
        field(70; Status; Enum "Auto Rent Header Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
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
            "No." := GetNewAutoRentHeaderNoFromNosSeries();
    end;

    trigger OnDelete()
    var
        AutoRentLines: Record "Auto Rent Line";
    begin
        AutoRentLines.SetRange("Document No.", Rec."No.");
        AutoRentLines.DeleteAll();
    end;

    procedure GetNewAutoRentHeaderNoFromNosSeries(): Code[20]
    var
        AutoSetup: Record "Auto Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        AutoSetup.Get();
        AutoSetup.TestField("Auto Rent Header Nos.");
        exit(NoSeriesManagement.GetNextNo(AutoSetup."Auto Rent Header Nos.", WorkDate(), true));
    end;

    procedure CheckReservation()
    var
        AutoReservation: Record "Auto Reservation";
        ReservationExist: Boolean;
        ReservationDoesNotExistLbl: Label 'Car %1 reservation from %2 to %3 does not exist to the customer %4.';
    begin
        TestStatusOpen();
        ReservationExist := false;
        AutoReservation.SetRange("Customer No.", Rec."Customer No.");
        AutoReservation.SetRange("Car No.", Rec."Car No.");
        AutoReservation.SetRange("Reserved From", Rec."Start Date");
        AutoReservation.SetRange("Reserved To", Rec."End Date");
        if not AutoReservation.FindSet() then
            Error(ReservationDoesNotExistLbl, Rec."Car No.", Rec."Start Date", Rec."End Date", Rec."Customer No.");

    end;

    procedure TestStatusOpen()
    begin
        TestField(Status, Status::Open);
    end;

    procedure CheckIsCustomerBlocked()
    var
        Customer: Record Customer;
        CustomerBlockedLbl: Label 'Customer %1 with No. %2 is blocked.';
    begin
        if Customer.Get(Rec."Customer No.") AND (Customer.Blocked <> Customer.Blocked::" ") then
            Error(CustomerBlockedLbl, Customer.Name, Rec."Customer No.");
    end;

    procedure CheckCustomerDebts()
    var
        Customer: Record Customer;
        CustomerHaveDebtsLbl: Label 'Customer %1 with No. %2 have debts.';
    begin
        if Customer.Get(Rec."Customer No.") then begin
            Customer.CalcFields("Balance (LCY)");
            if Customer."Balance (LCY)" > 0 then
                Error(CustomerHaveDebtsLbl, Customer.Name, Customer."No.");
        end;
    end;

    procedure InsertNewLine()
    var
        AutoRentLine: Record "Auto Rent Line";
        Auto: Record Auto;
        Resource: Record Resource;
    begin
        AutoRentLine.SetRange(Main, true);
        AutoRentLine.SetRange("Document No.", Rec."No.");
        if AutoRentLine.FindSet() then
            AutoRentLine.Delete();

        AutoRentLine.Init();
        AutoRentLine."Document No." := Rec."No.";
        AutoRentLine."Line No." := 10000;
        AutoRentLine.Type := AutoRentLine.Type::Resource;
        if Auto.Get(Rec."Car No.") then begin
            AutoRentLine."No." := Auto."Rent Service";
            if Resource.Get(Auto."Rent Service") then begin
                AutoRentLine.Description := Resource.Name;
                AutoRentLine.Amount := Resource."Unit Price";
                AutoRentLine."Base Unit of Measure" := Resource."Base Unit of Measure";
                AutoRentLine.Validate(Quantity, Rec."Duration in days");
                AutoRentLine.Main := true;
                AutoRentLine.Insert();
            end;
        end;
    end;

    procedure CalculateDurationDays()
    var
        DurationDecimal: Decimal;
    begin
        DurationDecimal := Rec."End Date" - Rec."Start Date";
        Rec."Duration in days" := Round((DurationDecimal) / 86400000, 1, '>');
    end;

    procedure CheckInvoiceDublicate()
    var
        AutoRentHeader: Record "Auto Rent Header";
        InvoiceDublicateErrLbl: Label 'This reservation already have invoice';
    begin
        AutoRentHeader.SetRange("Customer No.", Rec."Customer No.");
        AutoRentHeader.SetRange("Car No.", Rec."Car No.");
        AutoRentHeader.SetRange("Start Date", Rec."Start Date");
        AutoRentHeader.SetRange("End Date", Rec."End Date");
        if AutoRentHeader.FindSet() then
            Error(InvoiceDublicateErrLbl);
    end;

    procedure CheckFinishedInvoiceDublicate()
    var
        FinishedAutoRentHeader: Record "Finished Auto Rent Header";
        FinishedInvoiceDublicateErrLbl: Label 'This reservation already have finished invoice';
    begin
        FinishedAutoRentHeader.SetRange("Customer No.", Rec."Customer No.");
        FinishedAutoRentHeader.SetRange("Car No.", Rec."Car No.");
        FinishedAutoRentHeader.SetRange("Start Date", Rec."Start Date");
        FinishedAutoRentHeader.SetRange("End Date", Rec."End Date");
        if FinishedAutoRentHeader.FindSet() then
            Error(FinishedInvoiceDublicateErrLbl);
    end;

}