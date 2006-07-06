<#--
 *  Copyright (c) 2003 The Open For Business Project - www.ofbiz.org
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"), 
 *  to deal in the Software without restriction, including without limitation 
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 *  and/or sell copies of the Software, and to permit persons to whom the 
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included 
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
 *  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 *  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
 *  OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
 *  THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 *@author     Andy Zeneski (jaz@ofbiz.org)
 *@author     Jean-Luc.Malet@nereide.biz (migration to uiLabelMap)
 *@version    $Rev$
 *@since      2.2
-->

<#if returnHeader?exists>
<div class='tabContainer'>
    <a href="<@ofbizUrl>returnMain?returnId=${returnId?if_exists}</@ofbizUrl>" class="tabButtonSelected">${uiLabelMap.OrderReturnHeader}</a>  
    <a href="<@ofbizUrl>returnItems?returnId=${returnId?if_exists}<#if requestParameters.orderId?exists>&orderId=${requestParameters.orderId}</#if></@ofbizUrl>" class="tabButton">${uiLabelMap.OrderReturnItems}</a>
    <#if returnHeader?has_content && returnHeader.destinationFacilityId?has_content && returnHeader.statusId == "RETURN_ACCEPTED">
      <a href="/facility/control/ReceiveReturn?facilityId=${returnHeader.destinationFacilityId}&returnId=${returnHeader.returnId?if_exists}${externalKeyParam}" class="tabButton">${uiLabelMap.OrderReceiveReturn}</a>
    </#if>
</div>
<div>
    <a href="<@ofbizUrl>return.pdf?returnId=${returnId?if_exists}</@ofbizUrl>" class="buttontext">PDF</a>
</div>
<#else>
  <div class="head1">${uiLabelMap.OrderCreateNewReturn}</div>
  <#if requestParameters.returnId?has_content>
    <div class="head2">${uiLabelMap.OrderNoReturnFoundWithId} : ${requestParameters.returnId}</div>
  </#if>
  <br/>
</#if>

<#if returnHeader?exists>
<form name="returnhead" method="post" action="<@ofbizUrl>updateReturn</@ofbizUrl>">
<input type="hidden" name="returnId" value="${returnHeader.returnId}">
<input type="hidden" name="returnHeaderTypeId" value="CUSTOMER_RETURN"/>
<input type="hidden" name="currentStatusId" value="${returnHeader.statusId?if_exists}">
<#else>
<form name="returnhead" method="post" action="<@ofbizUrl>createReturn</@ofbizUrl>">
<input type="hidden" name="returnHeaderTypeId" value="CUSTOMER_RETURN"/>
</#if>

<table border='0' cellpadding='2' cellspacing='0'>
  <#if returnHeader?exists>
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.OrderReturnId}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%'>
      <b>${returnHeader.returnId}</b>
    </td>                
  </tr>
  </#if>
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.CommonCurrency}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%' class="tabletext">
  <#if returnHeader?exists>
      ${returnHeader.currencyUomId?if_exists}
  <#else>
     <select class="selectBox" name="currencyUomId">
        <#if (orderHeader?has_content) && (orderHeader.currencyUom?has_content)>
          <option value="${orderHeader.currencyUom}" selected>${orderHeader.getRelatedOne("Uom").getString("description",locale)}</option>
          <option value="${orderHeader.currencyUom}">---</option>
        <#elseif defaultCurrency?has_content>
          <option value="${defaultCurrency.uomId}" selected>${defaultCurrency.getString("description")}</option>
          <option value="${defaultCurrency.uomId}">---</option>
        </#if>
        <#if currencies?has_content>
          <#list currencies as currency>
            <option value="${currency.uomId}">${currency.get("description",locale)}</option>
          </#list>
        </#if>
     </select>
  </#if>
    </td>                
  </tr>
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.OrderEntryDate}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%'>
      <#if returnInfo.entryDate?exists>
        <#assign entryDate = returnInfo.get("entryDate").toString()>
      </#if>
      <input type='text' class='inputBox' size='25' name='entryDate' value='${entryDate?if_exists}'>
      <a href="javascript:call_cal(document.returnhead.entryDate, '');"><img src='/images/cal.gif' width='16' height='16' border='0' alt='Calendar'></a>
    </td>                
  </tr>
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.OrderReturnFromParty}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%'>
      <input type='text' class='inputBox' size='20' name='fromPartyId' value='${returnInfo.fromPartyId?if_exists}'>
    </td>                
  </tr>
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.OrderReturnToFacility}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%'>
      <select name='destinationFacilityId' class='selectBox'>
        <#if currentFacility?exists>
          <option value="${currentFacility.facilityId}">${currentFacility.facilityName?default(currentFacility.facilityId)}</option>
          <option value="${currentFacility.facilityId}">---</option>
        </#if>
        <option value="">${uiLabelMap.FacilityNoFacility}</option>
        <#list facilityList as facility>
          <option value="${facility.facilityId}" <#if (facilityList?size == 1)>selected</#if>>${facility.facilityName?default(facility.facilityId)}</option>
        </#list>
    </td>                
  </tr>  
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.AccountingBillingAccount}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%'>
      <#if billingAccountList?has_content>
        <select name='billingAccountId' class='selectBox'>
          <#if currentAccount?exists>
            <option value="${currentAccount.billingAccountId}">${currentAccount.billingAccountId}: ${currentAccount.description?if_exists}</option>
            <option value="${currentAccount.billingAccountId}">---</option>
          </#if>
          <option value="">${uiLabelMap.AccountingNewBillingAccount}</option>
          <#list billingAccountList as ba>
            <option value="${ba.billingAccountId}">${ba.billingAccountId}: ${ba.description?if_exists}</option>
          </#list>
        </select>
      <#else>
        <input type='text' class='inputBox' size='20' name='billingAccountId'>
      </#if>
    </td>                
  </tr>
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.OrderReturnNeedsAutoReceive}</div></td>
    <td width='6%'>&nbsp;</td>
    <td width='74%'>
      <select name='needsInventoryReceive' class='selectBox'>
        <#if needsInventoryReceive?exists>
          <option>${needsInventoryReceive}</option>
          <option value="${needsInventoryReceive}">---</option>
        </#if>
        <option>N</option>
        <option>Y</option>
      </select>
    </td>
  </tr>
  <#if returnHeader?has_content>
    <tr>
      <td width='14%'>&nbsp;</td>
      <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.CommonReturnStatus}</div></td>
      <td width='6%'>&nbsp;</td>
      <td width='74%'>
        <select name="statusId" class="selectBox">
          <#if currentStatus?exists>
            <option value="${currentStatus.statusId}">${currentStatus.get("description",locale)}</option>
            <option value="${currentStatus.statusId}">---</option>
          </#if>
          <#list returnStatus as status>
		  ${status}
            <option value="${status.statusIdTo}">${status.get("description",locale)}</option>
          </#list>
        </select>
      </td>
    </tr>
    <tr>
      <td width='14%'>&nbsp;</td>
      <td width='6%' align='right' nowrap><div class="tabletext">${uiLabelMap.FormFieldTitle_createdBy}</div></td>
      <td width='6%'>&nbsp;</td>
      <td width='74%'>
        <b>${returnHeader.createdBy?default("Unknown")}</b>
      </td>
    </tr>
    <tr>
      <td width='14%'>&nbsp;</td>
      <td width='6%' align='right' valign='top' nowrap><div class="tabletext">${uiLabelMap.OrderReturnFromAddress}</div></td>
      <td width='6%'>&nbsp;</td>
      <td width='74%'><div class='tabletext'>
        <#if (addressEditable)>
          <#list addresses as address >
            <@displayAddress postalAddress = address.postalAddress editable = true/>
          </#list>             
          <input type='radio' name="originContactMechId" value="" <#if (!postalAddressFrom?has_content)> checked="checked"</#if>>${uiLabelMap.CommonNoAddress}
        <#else>
            <#if (postalAddressFrom?has_content)>
              <@displayAddress postalAddress = postalAddressFrom editable = false />  
            <#else>
              ${uiLabelMap.CommonNoAddress}
            </#if>
        </#if>
      </div>
      </td>
    </tr>
     <tr>
      <td width='14%'>&nbsp;</td>
      <td width='6%' align='right' valign='top' nowrap><div class="tabletext">${uiLabelMap.OrderReturnToAddress}</div></td>
      <td width='6%'>&nbsp;</td>
      <td width='74%'>
      <#if (postalAddressTo?has_content)>
        <@displayAddress postalAddress = postalAddressTo editable=false />
      </#if>
      </td>
    </tr>    
    <tr>
      <td width='14%'>&nbsp;</td>
      <td width='6%'>&nbsp;</td>
      <td width='6%'>&nbsp;</td>   
      <td width='74%'>
        <input type="submit" class="standardButton" value="${uiLabelMap.CommonUpdate}">      
      </td>
    </tr>     
  <#else>
  <input type="hidden" name="statusId" value="RETURN_REQUESTED">
  <tr>
    <td width='14%'>&nbsp;</td>
    <td width='6%'>&nbsp;</td>
    <td width='6%'>&nbsp;</td>   
    <td width='74%'>
      <input type="submit" class="standardButton" value="${uiLabelMap.CommonCreateNew}">      
    </td>
  </tr>     
  </#if>
</table>
<#macro displayAddress postalAddress editable>
    <#if postalAddress?has_content>
            <div class="tabletext">
              <#if (editable)>
                <input type='radio' name="originContactMechId" value="${postalAddress.contactMechId?if_exists}" 
                  <#if ( postalAddressFrom?has_content && postalAddressFrom.contactMechId?default("") == postalAddress.contactMechId)>checked="checked"</#if>>        
              </#if>              
              <#if postalAddress.toName?has_content><b>${uiLabelMap.CommonTo}:</b>&nbsp;${postalAddress.toName}<br/></#if>
              <#if postalAddress.attnName?has_content><b>${uiLabelMap.CommonAttn}:</b>&nbsp;${postalAddress.attnName}<br/></#if>
              <#if postalAddress.address1?has_content>&nbsp;&nbsp;&nbsp;&nbsp;${postalAddress.address1}<br/></#if>
              <#if postalAddress.address2?has_content>&nbsp;&nbsp;&nbsp;&nbsp;${postalAddress.address2}<br/></#if>
              <#if postalAddress.city?has_content>&nbsp;&nbsp;&nbsp;&nbsp;${postalAddress.city}</#if>
              <#if postalAddress.stateProvinceGeoId?has_content>&nbsp;${postalAddress.stateProvinceGeoId}</#if>
              <#if postalAddress.postalCode?has_content>&nbsp;${postalAddress.postalCode}</#if>
              <#if postalAddress.countryGeoId?has_content><br/>&nbsp;&nbsp;&nbsp;&nbsp;${postalAddress.countryGeoId}</#if>
            </div>
    </#if>
</#macro>
