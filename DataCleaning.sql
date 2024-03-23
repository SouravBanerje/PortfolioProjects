/*
Cleaning Data in SQL Queries
*/

select * 
from PortfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------

--Standardize Data Format

select SaleDateConverted, convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate=convert(date,SaleDate);

alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing 
set SaleDateConverted = convert(date,SaleDate)



--------------------------------------------------------------------------

--Populate Property Address date

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------

--Breaking out Address into Individual Columns(Address, City, State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing



select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress  Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress=substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress))


select * from
PortfolioProject.dbo. NashvilleHousing

-------------

select OwnerAddress
from
PortfolioProject.dbo. NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing



alter table NashvilleHousing
add OwnerSplitAddress  Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)


alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


----Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2




select SoldAsVacant
, case when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject.dbo.NashvilleHousing



update NashvilleHousing
set SoldAsVacant =case when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	end




------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
with Delete_Duplicate_CTE as(
select *,
row_number()over(
partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
					UniqueID)as [row_num]
from PortfolioProject.dbo.NashvilleHousing
)

delete from Delete_Duplicate_CTE where row_num >1


