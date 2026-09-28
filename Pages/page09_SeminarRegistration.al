page 50109 "CSD Seminar Registration"
{
    Caption = 'Seminar Registration';
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CSD Seminar Reg. Header";
    PromotedActionCategories = 'Approval';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        If Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = All;
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ApplicationArea = All;
                }
                field("Instructor Resource No."; Rec."Instructor Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Duration (Minutes)"; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }

            }
            part(SeminarRegistrationLines; "CSD Registration Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            group("Seminar Room")
            {
                field("Room Resource No."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Room Name"; Rec."Room Name")
                {
                    ApplicationArea = All;
                }
                field("Room Address"; Rec."Room Address")
                {
                    ApplicationArea = All;
                }
                field("Room Address 2"; Rec."Room Address 2")
                {
                    ApplicationArea = All;
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                    ApplicationArea = All;
                }
                field("Room City"; Rec."Room City")
                {
                    ApplicationArea = All;
                }
                field("Room Country/Region Code"; Rec."Room Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Room County"; Rec."Room County")
                {
                    ApplicationArea = All;
                }
                group(Invoicing)
                {
                    field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("Seminar Price"; Rec."Seminar Price")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        area(Factboxes)
        {
            part(SeminarDetails; "CSD Seminar Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Seminar No.");
            }
            part(CustomerDetails; "Customer Details FactBox")
            {
                ApplicationArea = All;
                Provider = SeminarRegistrationLines; 
                SubPageLink = "No." = field("Bill-to Customer No.");
            }
            systempart(RecordLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Seminar Registration")
            {
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = page "CSD Seminar comment sheet";
                    RunPageLink = "No." = field("No.");
                    RunPageView = where("Table Name" = const("Seminar Registration"));
                }
                action("&Charges")
                {
                    ApplicationArea = All;
                    Caption = '&Charges';
                    Image = Cost;
                    RunObject = page "CSD Seminar Charge";
                    RunPageLink = "Document No." = field("No.");
                }
            }
        }
        area(Processing)
        {
            action(Reopen)
            {
                ApplicationArea = basic, suite;
                ToolTip = 'Reopen the record for changes';
                Caption = 'Reopen';
                Image = ReOpen;
                Enabled = (Rec."Approval Status" = Rec."Approval Status"::Approved) or (Rec."Approval Status" = Rec."Approval Status"::Rejected);
                promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    if Rec."Approval Status" in [rec."Approval Status"::Approved, Rec."Approval Status"::Rejected] then begin
                        Rec."Approval Status" := Rec."Approval Status"::Open;
                        rec.Status := Rec.Status::Registration;
                        Rec.Modify(true);
                        CurrPage.Close();
                    end;
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'Approve the record change';
                    Caption = 'Approve';
                    Image = Approve;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    promoted = true;
                    PromotedCategory = New;
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'Reject the record change';
                    Caption = 'Reject';
                    Image = Reject;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    promoted = true;
                    PromotedCategory = New;
                    trigger OnAction()
                    begin
                        Message('Reject');
                        ApprovalsMgmt.RejectRecordApprovalRequest(rec.RecordId);
                    end;
                }
                action(delegate)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'Delegate the record change';
                    Caption = 'Delegate';
                    Image = Delegate;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    promoted = true;
                    PromotedCategory = New;
                    trigger OnAction()
                    begin
                        Message('Delegate');
                        ApprovalsMgmt.DelegateRecordApprovalRequest(rec.RecordId);
                    end;
                }
                action(comment)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'View and Add a comment to the record change';
                    Caption = 'Comment';
                    Image = Comment;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    promoted = true;
                    PromotedCategory = New;
                    trigger OnAction()
                    begin
                        Message('Comment');
                        ApprovalsMgmt.GetApprovalComment(rec);
                    end;
                }
                action(approvals)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'View the approval history';
                    Caption = 'Approvals';
                    Image = Approvals;
                    promoted = true;
                    PromotedCategory = New;
                    trigger OnAction()
                    begin
                        Message('Approvals');
                        ApprovalsMgmt.OpenApprovalEntriesPage(rec.RecordId);
                    end;
                }
            }
            group(Posting)
            {
                Image = Post;
                Caption = 'Posting';

                action("P&ost")
                {
                    Caption = 'P&ost';
                    ApplicationArea = All;
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    // RunObject = codeunit "CSD Seminar PostYesNo";
                    trigger OnAction()
                    begin
                        if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                            Error('The record cannot be posted because it is not approved.');

                        // Call the posting codeunit or procedure
                        CODEUNIT.Run(CODEUNIT::"CSD Seminar PostYesNo", Rec);
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    Image = Print;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        SeminarReportSelection: Record "CSD Seminar Report Selections";
                    begin
                        SeminarReportSelection.PrintReportSelection
                        (SeminarReportSelection.Usage::Registration, Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'Send Approval to change the record';
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Enabled = not HasApprovalEntriesExist;
                    promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Custom Workflow Mgmt";
                        RecRef: RecordRef;
                    begin
                        // Message('Send Approval Request');
                        RecRef.GetTable(Rec);
                        if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then
                            CustomWorkflowMgmt.OnSendWorkFlowForApproval(RecRef);
                    end;
                }
                action(cancelApprovalRequest)
                {
                    ApplicationArea = basic, suite;
                    ToolTip = 'Cancel the Approval Request';
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Enabled = CanCancelApprovalForRecord;
                    promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Custom Workflow Mgmt";
                        RecRef: RecordRef;
                    begin
                        // Message('Cancel Approval Request');
                        RecRef.GetTable(Rec);
                        CustomWorkflowMgmt.OnCancelWorkFlowForApproval(RecRef);
                    end;
                }
            }
        }

    }
    trigger OnOpenPage()
    begin
        PageControls(Rec);
    end;

    trigger OnAfterGetCurrRecord()

    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        HasApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(rec.RecordId);
        PageControls(Rec);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if rec."Approval Status" <> Rec."Approval Status"::Open then
            Error('Record cannot be modified when Status is %1', Rec."Approval Status");
        // CheckModificationRestriction(Rec);
        //     exit(true);
    end;

    // procedure CheckModificationRestriction(var Rec: Record "CSD Registration Header"): Boolean
    // var
    //     RestrictionMgmt: Codeunit "Record Restriction Mgt.";
    // begin
    //     // Message('Checking modification restriction for Approval Status: %1', Rec."Approval Status");
    //     case Rec."Approval Status" of
    //         Rec."Approval Status"::Pending:
    //             begin
    //                 RestrictionMgmt.CheckRecordHasUsageRestrictions(Rec);
    //                 exit(false);
    //             end;
    //     end;
    //     exit(true);
    // end;
    procedure PageControls(var Rec: Record "CSD Seminar Reg. Header")
    begin
        if rec."Approval Status" = Rec."Approval Status"::Open then begin
            CurrPage.Editable := true;
            currpage.Update(false);
        end
        else begin
            CurrPage.Editable := false;
            currpage.Update(false);
        end;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistCurrUser: Boolean;
        HasApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
}