page 50107 "Auto Demage List"
{
    Caption = 'Auto Demage List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Auto Demage";
    SourceTableView = sorting("Car No.", "Demage Date");

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Car No."; Rec."Car No.")
                {
                    ApplicationArea = All;
                }
                field("Demage Date"; Rec."Demage Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}