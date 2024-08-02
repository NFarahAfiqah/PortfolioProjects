
--Data cleaning in SQL


-- Standardized Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject..NationalHousing

Update NationalHousing
Set SaleDate = CONVERT(Date, SaleDate)

-- If it does not Update properly

ALTER TABLE NationalHousing
Add SaleDateConverted Date;

Update NationalHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

----------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject..NationalHousing
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NationalHousing a
JOIN PortfolioProject..NationalHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NationalHousing a
JOIN PortfolioProject..NationalHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is null

----------------------------------------------------------------------

--Breaking out Address into individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NationalHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject..NationalHousing

ALTER TABLE NationalHousing
Add PropertySplitAddress Nvarchar(255);

Update NationalHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NationalHousing
Add PropertySplitCity Nvarchar(255);

Update NationalHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject..NationalHousing

Select OwnerAddress
From PortfolioProject..NationalHousing
Where OwnerAddress is not null

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NationalHousing

ALTER TABLE NationalHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE NationalHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE NationalHousing
Add OwnerSplitState Nvarchar(255);


Update NationalHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Update NationalHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Update NationalHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


----------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NationalHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END
From PortfolioProject..NationalHousing

Update PortfolioProject..NationalHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END

---------------------------------------------------------------------

-- Removing Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject..NationalHousing
--Order by ParcelID
)
Select *  --Change Select to DELETE to delete the duplicates
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


----------------------------------------------------------------------

--Delete Unused Colmuns


Select *
From PortfolioProject..NationalHousing

ALTER TABLE PortfolioProject..NationalHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NationalHousing
DROP COLUMN SaleDate

