page 50100 "Auto Setup Card"
{
    Caption = 'Auto Setup Card';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Auto Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Auto Nos."; Rec."Auto Nos.")
                {
                    ApplicationArea = All;
                }
                field("Auto Rent Header Nos."; Rec."Auto Rent Header Nos.")
                {
                    ApplicationArea = All;
                }
                field("Transfer Nos."; Rec."Transfer Nos.")
                {
                    ApplicationArea = All;
                }
                field("Items warehouse location code"; Rec."Items warehouse location code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExist();
    end;
}