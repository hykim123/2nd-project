<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/jsp/common/header.jsp" %>
<c:set var="count" value="0" scope="page"/>
<div style="width: 80%; margin: 0 auto;">
    <div class="search-group">
        <h2> 주문 내역</h2>
        <form class="search-bar" action="/WangBam/">
            <input type="hidden" name="type" value="order">
            <input type="text" id="searchProductName" name="searchValue" placeholder="Search..." />
            <button type="button" class="btn search" id="searchBtn"></button>
        </form>
    </div>
</div>
<c:forEach var="ovo" items="${requestScope.o_list}">
<c:set var="count" value="${count+1}" scope="page"/>
<div class="order-container" style="margin-bottom: 10px;">
        <div class="order-header">
            <h2>주문번호: ${ovo.or_idx}</h2>
            <a href="?type=orderdetail&or_idx=${ovo.or_idx}">주문 상세보기 &gt;</a>
        </div>
        <div class="order-status">
        <c:if test="${ovo.or_status_code == 'UNKNOWN'}">
            <span class="status-value">주문완료</span>
        </c:if>
        <c:if test="${ovo.or_status_code == 'INFORMATION_RECEIVED'}">
            <span class="status-value">배송중</span>
        </c:if>
        <c:if test="${ovo.or_status_code == 'DELIVERED'}">
            <span class="status-value">배송완료</span>
        </c:if>
        <c:if test="${ovo.or_status_code == 'CANCELLED'}">
            <span class="status-value">주문취소</span>
        </c:if>
        <c:if test="${ovo.or_status_code == 'UNKNOWN_WAIT'}">
            <span class="status-value">환불대기</span>
        </c:if>
    	</div>
        <c:forEach var="odvo" items="${ovo.od_list}">
        <div class="order-item">
            <img src="img/${odvo.pvo.pd_thumbnail_img}" class="order-img" alt="Product Image">
            <div class="order-item-details">
                <h3>${odvo.pvo.pd_name}</h3>
                <p><c:if test="${odvo.pvo.pd_sale_price != null}">
				<fmt:formatNumber value="${odvo.pvo.pd_sale_price}" var="sale_price"/>
				${ sale_price }원
				</c:if>
                <c:if test="${odvo.pvo.pd_price != null&&odvo.pvo.pd_sale_price == null}">
				<fmt:formatNumber value="${odvo.pvo.pd_price}" var="price"/>
				${ price } 원
				</c:if>
                &nbsp; &nbsp;  ${odvo.od_cnt}개</p>
            </div>
            <c:if test="${ovo.or_status_code == 'DELIVERED'}">
	        <div class="order-actions">
	    		<button onclick="location.href='/WangBam/?type=reviewWrite&pd_idx=${odvo.pvo.pd_idx}'">리뷰 작성</button>
			</div>
			</c:if>	
        </div>
        </c:forEach>
        <div class="order-total-price">
            <fmt:formatNumber value="${ovo.or_total_price+4000}" pattern="#,###" var="totalPrice"/>
            <span>총 결제금액: ${totalPrice}원 (배송비포함)</span>
        </div>
    </div>
</c:forEach>
<c:if test="${count == 0}">
<div class="order-container" style="text-align: center;">
    <h2>주문내역이 없습니다.</h2>
</div>
</c:if>
<div class="pagination">
			<c:set var="page" value="${requestScope.page }"/>
			
			<c:if test="${page.startPage < page.pagePerBlock }">
            	<div class="disable">&lt;</div>
			</c:if>
			<c:if test="${page.startPage >= page.pagePerBlock }">
				<div><a href="?type=order&cPage=${page.nowPage-page.pagePerBlock }">&lt;</a></div>
			</c:if>


			<c:forEach begin="${page.startPage }" end="${page.endPage }" varStatus="vs">
          		<c:if test="${vs.index eq page.nowPage }">
          			<div class="on">${vs.index }</div>
           		</c:if>
				<c:if test="${vs.index ne page.nowPage }">
					<div><a href="?type=order&cPage=${vs.index }">${vs.index }</a></div>
				</c:if>
			</c:forEach>
			
			
			<c:if test="${page.endPage < page.totalPage}">
				<c:if test="${page.nowPage+page.pagePerBlock > page.totalPage }">
					<div><a href="?type=order&cPage=${page.totalPage }">&gt;</a></div>
				</c:if>
				<c:if test="${page.nowPage+page.pagePerBlock <= page.totalPage }">
					<div><a href="?type=order&cPage=${page.nowPage+page.pagePerBlock}">&gt;</a></div>
				</c:if>
			</c:if>
			<c:if test="${page.endPage >= page.totalPage}">
				<div class="disable">&gt;</div>
			</c:if>
  	</div>

<%@include file="/jsp/common/footer.jsp" %>
<script>
    $(document).ready(function(){
        $('#searchBtn').click(function(){
            if($('#searchProductName').val() == null){
                alert("검색어를 입력해주세요.");
                return false;
            }
            $('.search-bar').submit();
        });
    });
</script>
  </body>
</html>