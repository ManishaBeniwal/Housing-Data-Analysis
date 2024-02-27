------------======================= PROJECT -> DATA CLEANING IN SQL ===========================-------------------------

--looking it data
 SELECT  TOP 50 *  
 FROM NashvilleHousing;

 --Standardize data format in SaleDate Column from DATETIME To Date 

 ALTER TABLE NashvilleHousing
 ALTER COLUMN SaleDate DATE ;

 -- Populate Property Address Data

 SELECT  * FROM NashvilleHousing
 WHERE PropertyAddress IS NULL;

 SELECT N1.ParcelID , N1.PropertyAddress,N2.ParcelID,N2.PropertyAddress ,ISNULL(N1.PropertyAddress, N2.PropertyAddress)
 FROM NashvilleHousing N1 INNER JOIN NashvilleHousing N2
 ON N1.ParcelID = N2.ParcelID
 WHERE N1.UniqueID <>  N2.UniqueID AND N1.PropertyAddress IS NULL

 UPDATE N1
 SET N1.PropertyAddress = ISNULL(N1.PropertyAddress, N2.PropertyAddress)
 FROM NashvilleHousing N1 INNER JOIN NashvilleHousing N2
 ON N1.ParcelID = N2.ParcelID
 WHERE N1.UniqueID <>  N2.UniqueID AND N1.PropertyAddress IS NULL

 SELECT top  50 * FROM NashvilleHousing 

 -- Splitting PropertyAddress into individual columns (Address, City)

 SELECT PropertyAddress
 FROM NashvilleHousing 

 SELECT LEFT(PropertyAddress,CHARINDEX(',',PropertyAddress)-1) AS property_split_address,
 RIGHT(PropertyAddress,LEN(PropertyAddress)-(CHARINDEX(',',PropertyAddress)+1) )AS property_split_city
 FROM NashvilleHousing ;
 
 --add column property_split_address
 ALTER TABLE NashvilleHousing 
 ADD property_split_address NVARCHAR(255)

UPDATE NashvilleHousing 
SET property_split_address =  LEFT(PropertyAddress,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing 
 ADD property_split_city NVARCHAR(255)

 UPDATE NashvilleHousing 
SET property_split_city = RIGHT(PropertyAddress,LEN(PropertyAddress)-(CHARINDEX(',',PropertyAddress)+1) )

SELECT TOP  50 * 
 FROM NashvilleHousing 

 -- Splitting OwnerAddress into individual columns (Address, City, State)
 SELECT TOP  50  *
 FROM NashvilleHousing 

 SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Owner_split_Address,
  PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS  Owner_split_city,
 PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS Owner_split_STATE
 FROM NashvilleHousing ;


 ALTER TABLE NashvilleHousing
 ADD Owner_split_Address NVARCHAR(255)

 UPDATE NashvilleHousing
 SET Owner_split_Address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE NashvilleHousing
ADD Owner_Split_City NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_Split_City = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2));

ALTER TABLE NashvilleHousing
ADD Owner_Split_State NVARCHAR(25);

UPDATE NashvilleHousing
SET Owner_Split_State = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1));
 

 SELECT  TOP 50 * FROM NashvilleHousing

 -- Replace values 'Y' & 'N' To 'Yes' & 'No' In SoldAsVacant Column
 SELECT SoldAsVacant , COUNT(SoldAsVacant) AS counts
 FROM NashvilleHousing
 GROUP BY SoldAsVacant;


UPDATE NashvilleHousing
SET SoldAsVacant =
CASE 
   WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
   END ;

 -- Removing Duplicates from our data. Please note this is not advisable when working on real dataset.
 WITH CTE AS 
 (SELECT *,
 ROW_NUMBER() OVER (PARTITION BY ParcelID, 
		PropertyAddress, 
		SalePrice, 
		SaleDate, 
		LegalReference
		ORDER BY UniqueID) AS row_no 
 FROM NashvilleHousing)
DELETE 
FROM CTE 
WHERE row_no >1;

SELECT * FROM  NashvilleHousing


-- Removing unused columns from our data - It is not advisable to remove columns from original dataset

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict;



------------------------------------------ THE END -----------------------------------------










