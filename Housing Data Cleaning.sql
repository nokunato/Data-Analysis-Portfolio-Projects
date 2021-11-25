select *
from [Portfolio projects]..[Housing DB]

--correcting the saledate column
select SaleDate, convert(Date, SaleDate)
from [Portfolio projects]..[Housing DB]

update [Portfolio projects]..[Housing DB]
set SaleDate = convert(Date, SaleDate)

-- Property address issue

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio projects]..[Housing DB] a
join [Portfolio projects]..[Housing DB] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
--where b.PropertyAddress is null

update b
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio projects]..[Housing DB] a
join [Portfolio projects]..[Housing DB] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where b.PropertyAddress is null

-- Breaking out Addresses into Individual columns

select *
from [Portfolio projects]..[Housing DB]

select PARSENAME(replace(PropertyAddress, ',', '.'), 2), 
PARSENAME(replace(PropertyAddress, ',', '.'), 1)
from [Portfolio projects]..[Housing DB]

Alter table [Portfolio projects]..[Housing DB]
add PropertySplitAddress Nvarchar(255);

Update [Portfolio projects]..[Housing DB]
set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

Alter table [Portfolio projects]..[Housing DB]
add PropertySplitCity Nvarchar(255);

Update [Portfolio projects]..[Housing DB]
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress));

select
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2), 
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from [Portfolio projects]..[Housing DB]

Alter table [Portfolio projects]..[Housing DB]
add OwnerSplitAddress Nvarchar(255);

Update [Portfolio projects]..[Housing DB]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter table [Portfolio projects]..[Housing DB]
add OwnerSplitCity Nvarchar(255);

Update [Portfolio projects]..[Housing DB]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table [Portfolio projects]..[Housing DB]
add OwnerSplitState Nvarchar(255);

Update [Portfolio projects]..[Housing DB]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Change Y and N to Yes and No

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Portfolio projects]..[Housing DB]
group by SoldAsVacant
order by 2

select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End
from [Portfolio projects]..[Housing DB]

Update [Portfolio projects]..[Housing DB]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End


-- Remove Duplicates

with RowNumCTE as (
select *, ROW_NUMBER() over(
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER by
	UniqueID
	) row_num
from [Portfolio projects]..[Housing DB]
)
Delete
from RowNumCTE
where row_num > 1
)

-- delete unused columns

alter table [Portfolio projects]..[Housing DB]
drop column OwnerAddress, TaxDistrict, PropertyAddress
alter table [Portfolio projects]..[Housing DB]
drop column SaleDate