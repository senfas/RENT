page 50118 "Finished Auto Rent Header Card"
{
    Caption = 'Finished Auto Rent Header Card';
    PageType = Card;
    SourceTable = "Finished Auto Rent Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Car)
            {
                Caption = 'Information about Auto';
                field("Car No."; Rec."Car No.")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Duration in days"; Rec."Duration in days")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
            part(lines; "Finished Auto Rent Line Sub")
            {
                SubPageLink = "Document No." = field("No.");
                SubPageView = sorting("Document No.", "Line No.");
            }
        }
        area(FactBoxes)
        {
            part(DriverLicense; "Finished License Pic. FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }

    }
}