use Northwind

Insert into customers(CustomerId,CompanyName,Phone)
values('qwe','AZE','0501112222'),
('wer','AZE','501112222'),
('ert','AZE','9940501112222'),
('rty','AZE','+9940501112222'),
('tyu','AZE','1112222'),
('yui','AZE','+8740501112222')


CREATE FUNCTION SqlFormat(@phone nvarchar(max))
RETURNS nvarchar(max)
BEGIN 
Declare @code nvarchar(4) = '+994';
Declare @prefix nvarchar(2) = '';
Declare @number nvarchar(7) = '';
Declare @phonePart1 nvarchar(3) = '';
Declare @phonePart2 nvarchar(2) = '';
Declare @phonePart3 nvarchar(2) = '';

         IF Len(@phone) < 9  
		 BEGIN 
		     Set @phone = 'Telefon nomresi en az 9 simvoldan ibaret olmalidir.'
			 RETURN @phone;
		 END 

	     ElSE 
		 BEGIN
		          IF LEFT(@phone,3) in ('050','051','055','070','077') and Len(@phone) = 10
                  BEGIN
		              Set @prefix = SUBSTRING(@phone,2, 2)
		              Set @number = Right(@phone,Len(@phone)-3);
                  END

		          ELSE IF LEFT(@phone,2) in ('50','51','55','70','77') and Len(@phone) = 9
                  BEGIN
		              Set @prefix = SUBSTRING(@phone,1, 2)
		              Set @number = Right(@phone,Len(@phone)-2);
                  END

		          ELSE IF LEFT(@phone,3) = '994' and Len(@phone) = 13
                  BEGIN
		              Set @prefix = SUBSTRING(@phone, 5, 2)
		              Set @number = Right(@phone,Len(@phone)-6);
                  END

		          ELSE IF LEFT(@phone,4) = '+994' and Len(@phone) = 14
                  BEGIN
		              Set @prefix = SUBSTRING(@phone, 6, 2)
		              Set @number = Right(@phone,Len(@phone)-7);
                  END

		          ELSE
		          BEGIN 
		              SET @phone = 'Telefon nomresi duzgun formatda deyil.';
                      RETURN @phone;
		          END
       END

	    SET @phonePart1 = SUBSTRING(@number, 1, 3);
        SET @phonePart2 = SUBSTRING(@number, 4, 2);
        SET @phonePart3 = SUBSTRING(@number, 6, 2);

        -- Final phone format
        SET @phone = @code + ' (' + @prefix + ') ' + @phonePart1 + ' ' + @phonePart2 + ' ' + @phonePart3;

	 RETURN @phone
END

Select CustomerId, phone, dbo.SqlFormat(phone) from dbo.Customers Where CompanyName = 'AZE'
