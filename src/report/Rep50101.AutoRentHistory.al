report 50101 "Auto Rent History"
{
    Caption = 'Auto Rent History';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    WordMergeDataItem = Auto;
    RDLCLayout = './src/ReportsLayouts/AutoRentHistory.rdl';

    dataset
    {
        dataitem(Auto; Auto)
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Auto_Mark; AutoMarkRecord.Description) { }
            column(Auto_Model; AutoModelRecord.Description) { }
            column(StartingDate; StartingDate) { }
            column(EndingDate; EndingDate) { }
            column(Car_No_Caption_Lbl; Car_No_Caption_Lbl) { }
            column(Make_Caption_Lbl; Make_Caption_Lbl) { }
            column(Model_Caption_Lbl; Model_Caption_Lbl) { }
            column(Today_Date; TodayDate) { }
            dataitem(FinishedAutoRentHeader; "Finished Auto Rent Header")
            {
                DataItemLink = "Car No." = field("No.");
                DataItemTableView = sorting("Start Date");
                column(Start_Date; "Start Date") { }
                column(End_Date; "End Date") { }
                column(Customer_Name; Customer.Name) { }
                column(Total_Amount; "Total Amount") { }
                column(StartDate_HeaderCaption; FinishedAutoRentHeader.FieldCaption("Start Date")) { }
                column(EndDate_HeaderCaption; FinishedAutoRentHeader.FieldCaption("End Date")) { }
                column(CustomerName_HeaderCaption; Customer.FieldCaption(Name)) { }
                column(TotalAmount_HeaderCaption; FinishedAutoRentHeader.FieldCaption("Total Amount")) { }
                trigger OnAfterGetRecord()
                begin
                    if not Customer.Get("Customer No.") then
                        Customer.Init()
                    else
                        Customer.TestField(Name);

                end;

                trigger OnPreDataItem()
                begin
                    if StartingDate <> 0DT then
                        FinishedAutoRentHeader.SetFilter("Start Date", '>=%1', StartingDate);
                    if EndingDate <> 0DT then
                        FinishedAutoRentHeader.SetFilter("End Date", '<=%1', EndingDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not Auto.Get("No.") then
                    Auto.init();

                if not AutoMarkRecord.Get(Auto.Mark) then
                    AutoMarkRecord.Init()
                else
                    AutoMarkRecord.TestField(Description);

                if not AutoModelRecord.Get(Auto.Mark, Auto.Model) then
                    AutoModelRecord.Init()
                else
                    AutoModelRecord.TestField(Description);
                TodayDate := WorkDate();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(ReservationDates)
                {
                    Caption = 'Dates';
                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                    field(EndingDate; EndingDate)
                    {
                        Caption = 'Ending Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }


    var
        Customer: Record Customer;
        AutoMarkRecord: Record "Auto Mark";
        AutoModelRecord: Record "Auto Model";
        StartingDate: DateTime;
        EndingDate: DateTime;
        TodayDate: Date;
        Car_No_Caption_Lbl: Label 'Car No.';
        Make_Caption_Lbl: Label 'Make';
        Model_Caption_Lbl: Label 'Model';
}