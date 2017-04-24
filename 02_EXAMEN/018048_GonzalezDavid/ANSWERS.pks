CREATE OR REPLACE PACKAGE EX2GON.answers
AS
    procedure prob1 (out_band_info OUT sys_refcursor);
    
    procedure prob2 (out_concert OUT sys_refcursor);
    
    procedure prob3 (out_band OUT sys_refcursor);
    
    procedure prob4 (out_venue OUT sys_refcursor);
        
END answers;
/
