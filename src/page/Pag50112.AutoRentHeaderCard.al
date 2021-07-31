page 50112 "Auto Rent Header Card"
{
    Caption = 'Auto Rent Header Card';
    PageType = Card;
    SourceTable = "Auto Rent Header";

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

                    trigger OnAssistEdit()
                    begin
                        if Rec."No." = '' then
                            Rec."No." := Rec.GetNewAutoRentHeaderNoFromNosSeries();
                    end;
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
            group(StatusGrp)
            {
                Caption = 'Status';
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            part(lines; "Auto Rent Line Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                SubPageView = sorting("Document No.", "Line No.");

            }
        }
        area(FactBoxes)
        {
            part(DriverLicense; "Driver License Picture FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
            part(RentDemage; "Auto Rent Demage FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }


    actions
    {
        area(Navigation)
        {
            action(OpenAutoRentDemageList)
            {
                Caption = 'Auto Rent Demage List';
                ApplicationArea = All;
                Image = Open;

                trigger OnAction()
                var
                    AutoRentDemage: Record "Auto Rent Demage";
                    AutoRentDemageList: Page "Auto Rent Demage List";
                begin
                    AutoRentDemage.SetRange("Document No.", Rec."No.");
                    AutoRentDemageList.SetTableView(AutoRentDemage);
                    AutoRentDemageList.RunModal();
                end;
            }
        }
        area(Reporting)
        {
            action(AutoRentHeaderReport)
            {
                Caption = 'Rent Report';
                ApplicationArea = All;
                Image = Report;

                trigger OnAction()
                var
                    AutoRentHeader: Record "Auto Rent Header";
                    AutoRentHeaderReport: Report "Auto Rent Header Report";
                begin
                    AutoRentHeader.SetRange("No.", Rec."No.");
                    AutoRentHeaderReport.SetTableView(AutoRentHeader);
                    AutoRentHeaderReport.RunModal();
                end;
            }
        }
        area(Processing)
        {
            action(AutoRentHeaderReOpen)
            {
                Caption = 'Open';
                ApplicationArea = All;
                Image = ReOpen;
                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    ReleaseAutoRentHeader: Codeunit "Release Auto Rent Header";
                    ItemMgmt: Codeunit "Item Management";
                begin
                    ReleaseAutoRentHeader.PerformManualReOpen(Rec);

                    ItemMgmt.TransferItemFromAuto(Rec);
                end;
            }
            action(AutoRentHeaderRelease)
            {
                Caption = 'Release';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = Rec.Status = Rec.Status::Open;

                trigger OnAction()
                var
                    ReleaseAutoRentHeader: Codeunit "Release Auto Rent Header";
                    ItemMgmt: Codeunit "Item Management";
                begin
                    ReleaseAutoRentHeader.PerformManualRelease(Rec);

                    ItemMgmt.TransferItemsToAuto(Rec);
                end;
            }
            action(ReturnAuto)
            {
                Caption = 'Return Auto';
                ApplicationArea = All;
                Image = Return;
                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    AutoDemage: Record "Auto Demage";
                    AutoRentDemage: Record "Auto Rent Demage";
                    AutoRentLine: Record "Auto Rent Line";
                    FinishedAutoRentLine: Record "Finished Auto Rent Line";
                    FinishedAutoRentHeader: Record "Finished Auto Rent Header";
                    TempBlob: Codeunit "Temp Blob";
                    InS: InStream;
                    OutS: OutStream;
                    ItemMgmt: Codeunit "Item Management";
                begin
                    ItemMgmt.TransferItemFromAuto(Rec);

                    AutoRentDemage.SetRange("Document No.", Rec."No.");
                    if AutoRentDemage.FindSet() then
                        repeat
                            AutoDemage.Init();
                            AutoDemage."Car No." := Rec."Car No.";
                            AutoDemage."Line No." := AutoDemage.GetNewLineNo();
                            AutoDemage."Demage Date" := AutoRentDemage."Demage Date";
                            AutoDemage.Description := AutoRentDemage.Description;
                            AutoDemage.Status := AutoDemage.Status::Active;
                            AutoDemage.Insert();
                        until AutoRentDemage.Next() = 0;

                    AutoRentLine.Reset();
                    AutoRentLine.SetRange("Document No.", Rec."No.");
                    if AutoRentLine.FindSet() then
                        repeat
                            FinishedAutoRentLine.Init();
                            FinishedAutoRentLine."Document No." := Rec."No.";
                            FinishedAutoRentLine."Line No." := AutoRentLine."Line No.";
                            FinishedAutoRentLine.Type := AutoRentLine.Type;
                            FinishedAutoRentLine."No." := AutoRentLine."No.";
                            FinishedAutoRentLine.Description := AutoRentLine.Description;
                            FinishedAutoRentLine."Base Unit of Measure" := AutoRentLine."Base Unit of Measure";
                            FinishedAutoRentLine.Quantity := AutoRentLine.Quantity;
                            FinishedAutoRentLine.Amount := AutoRentLine.Amount;
                            FinishedAutoRentLine."Total Amount" := AutoRentLine."Total Amount";
                            FinishedAutoRentLine.Insert();
                        until AutoRentLine.Next() = 0;

                    FinishedAutoRentHeader.Init();
                    FinishedAutoRentHeader."No." := Rec."No.";
                    FinishedAutoRentHeader."Customer No." := Rec."Customer No.";
                    FinishedAutoRentHeader."Duration in days" := Rec."Duration in days";
                    TempBlob.CreateOutStream(OutS);
                    Rec."Driver License".ExportStream(OutS);
                    TempBlob.CreateInStream(InS);
                    FinishedAutoRentHeader."Driver License".ImportStream(InS, '');
                    FinishedAutoRentHeader."Posting Date" := Rec."Posting Date";
                    FinishedAutoRentHeader."Car No." := Rec."Car No.";
                    FinishedAutoRentHeader."Start Date" := Rec."Start Date";
                    FinishedAutoRentHeader."End Date" := Rec."End Date";
                    FinishedAutoRentHeader."Total Amount" := Rec."Total Amount";
                    FinishedAutoRentHeader.Insert();

                    AutoRentDemage.DeleteAll();
                    AutoRentLine.DeleteAll();
                    Rec.Delete();
                end;
            }
        }
    }
}