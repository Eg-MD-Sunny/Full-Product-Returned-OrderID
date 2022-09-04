select  s.orderid OrderId,
       s.shipmentTag,
       st.name [Store],
       cast(dbo.tobdt(o.CreatedOnUtc)as smalldatetime)[CreatedOn],
       cast(dbo.tobdt(s.reconciledon) as smalldatetime) Reconciledon,
       sum(tr.saleprice) Ordervalue,
       dbo.GetEnumName('ShipmentStatus',ShipmentStatus) ShipmentStatus,
       s.deliveryFee [DeliveryFee]

from Shipment s
join thingrequest tr on tr.shipmentid=s.id
join [order] o on o.id=s.OrderId
join store st on st.id = o.storeId
join ProductVariant pv on pv.id = tr.ProductVariantId

where pv.distributionNetworkId = 2

and o.id in (
	select  s.orderid 
         


from ProductVariant pv
join ThingRequest tr on tr.ProductVariantId=pv.id
join Shipment s on s.id=tr.ShipmentId

where pv.DistributionNetworkId = 2
group by s.orderid
having count(pv.id) = count(case when tr.IsReturned  = 1 then pv.id else null end)

)

group by  s.orderid,
          s.shipmentTag,
          st.name,
          cast(dbo.tobdt(o.CreatedOnUtc)as smalldatetime),
          cast(dbo.tobdt(s.reconciledon) as smalldatetime),
          dbo.GetEnumName('ShipmentStatus',ShipmentStatus),
          s.deliveryFee 



order by 1 

