tableextension 50101 "CSD SourceCodeSetupExt" extends "Source Code Setup"
{
    fields
    {
        
        field(50100;"CSD Seminar";Code[10]) 
        {
            Caption = 'Seminar';
            TableRelation = "Source Code";
        }
    }
    
    keys
    {
        // Add changes to keys here
    }
    
    fieldgroups
    {
        // Add changes to field groups here
    }
    
    var
        myInt: Integer;
}

// Source codes simplify locating transactions that originated from a specific application function, such as a journal or a batch job.

// when customizing Dynamics 365 BC to include new posting routines or batch jobs that result in posted entries, you must extend the Source Code Setup table and page by using a field that identifies any new transaction type that you are introducing. then in your posting routines, you must make sure that you use tha field to identify the transactions that originated from that new feature.

// therefore, you establish an audit trail that is consistent with other features of Dynamics 365 BC.