-- Cleaning data using SQL Queries

Select *
From [Portfolio Project].[dbo].[NashvilleHousing]

-- Standardize date format

Select SaleDate2, CONVERT(Date,SaleDate)
From [Portfolio Project].[dbo].[NashvilleHousing]

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET SaleDate = CONVERT(Date,SaleDate)
-- Alternate way to do this:
ALTER TABLE NashvilleHousing
Add SaleDate2 Date;

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET SaleDate2 = CONVERT(Date,SaleDate)

--Populate Property Address data

Select *
From [Portfolio Project].[dbo].[NashvilleHousing]
--Where PropertyAddress is Null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].[dbo].[NashvilleHousing] a
JOIN [Portfolio Project].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].[dbo].[NashvilleHousing] a
JOIN [Portfolio Project].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out address into individual columns (Address, City, State)

Select PropertyAddress
From [Portfolio Project].[dbo].[NashvilleHousing]
--Where PropertyAddress is Null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From [Portfolio Project].[dbo].[NashvilleHousing]

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From [Portfolio Project].[dbo].[NashvilleHousing]

--Change Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From [Portfolio Project].[dbo].[NashvilleHousing]

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate2,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project].[dbo].[NashvilleHousing]

--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio Project].[dbo].[NashvilleHousing]

-- Delete Unused Columns

Select *
From [Portfolio Project].[dbo].[NashvilleHousing]

ALTER TABLE [Portfolio Project].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

