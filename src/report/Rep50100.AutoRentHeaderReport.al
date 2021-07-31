report 50100 "Auto Rent Header Report"
{
    Caption = 'Auto Rent Header Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportsLayouts/AutoRentHeaderReport.rdl';

    dataset
    {
        dataitem("Auto Rent Header"; "Auto Rent Header")
        {
            RequestFilterFields = "No.";
            column(Posting_Date; "Posting Date") { }
            column(No_; "No.") { }
            column(Car_No_; "Car No.") { }
            column(Driver_License; "Driver License") { }
            column(Start_Date; "Start Date") { }
            column(End_Date; "End Date") { }
            column(Duration_in_days; "Duration in days") { }
            column(Header_Total_Amount; "Total Amount") { }
            column(Auto_Mark; AutoMarkRecord.Description) { }
            column(Auto_Model; AutoModelRecord.Description) { }
            column(Customer_Name; Customer.Name) { }
            column(Contract_No_Caption_Lbl; Contract_No_Caption_Lbl) { }
            column(Customer_Name_Caption_Lbl; Customer_Name_Caption_Lbl) { }
            column(Car_No_Caption_Lbl; Car_No_Caption_Lbl) { }
            column(Make_Caption_Lbl; Make_Caption_Lbl) { }
            column(Model_Caption_Lbl; Model_Caption_Lbl) { }
            column(Start_Date_Caption_Lbl; Start_Date_Caption_Lbl) { }
            column(End_Date_Caption_Lbl; End_Date_Caption_Lbl) { }
            dataitem("Auto Rent Line"; "Auto Rent Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Type; Type) { }
                column(Description; Description) { }
                column(Base_Unit_of_Measure; "Base Unit of Measure") { }
                column(Quantity; Quantity) { }
                column(Amount; Amount) { }
                column(Total_Amount; "Total Amount") { }
                column(Main; Main) { }
                column(Descr_RentLineCaption; "Auto Rent Line".FieldCaption(Description)) { }
                column(BUoM_RentLineCaption; "Auto Rent Line".FieldCaption("Base Unit of Measure")) { }
                column(Quant_RentLineCaption; "Auto Rent Line".FieldCaption(Quantity)) { }
                column(Amount_RentLineCaption; "Auto Rent Line".FieldCaption(Amount)) { }
                column(TotAmount_RentLineCaption; "Auto Rent Line".FieldCaption("Total Amount")) { }
            }

            trigger OnAfterGetRecord()
            begin
                if not Auto.Get("Auto Rent Header"."Car No.") then
                    Auto.init();

                if not AutoMarkRecord.Get(Auto.Mark) then
                    AutoMarkRecord.Init()
                else
                    AutoMarkRecord.TestField(Description);

                if not AutoModelRecord.Get(Auto.Mark, Auto.Model) then
                    AutoModelRecord.Init()
                else
                    AutoModelRecord.TestField(Description);

                if not Customer.Get("Customer No.") then
                    Customer.Init()
                else
                    Customer.TestField(Name);
            end;
        }

    }

    var
        Auto: Record Auto;
        Customer: Record Customer;
        AutoMarkRecord: Record "Auto Mark";
        AutoModelRecord: Record "Auto Model";
        Contract_No_Caption_Lbl: Label 'Invoice No.';
        Customer_Name_Caption_Lbl: Label 'Customer Name';
        Car_No_Caption_Lbl: Label 'Car No.';
        Make_Caption_Lbl: Label 'Make';
        Model_Caption_Lbl: Label 'Model';
        Start_Date_Caption_Lbl: Label 'Start Date';
        End_Date_Caption_Lbl: Label 'End Date';
}