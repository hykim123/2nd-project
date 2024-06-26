<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="/jsp/common/header.jsp"%>
<style>
.total {
	margin: 0;
	height: 90px;
}
</style>
<table class="table1">
	<thead>
		<tr>
			<th>선택</th>
			<th>이미지</th>
			<th>상품명</th>
			<th>가격</th>
			<th>수량</th>
			<th>합계</th>
			<th>삭제</th>
		</tr>
	</thead>

	<tbody>
		<c:if test="${cvo != null}">
			<c:forEach var="vo" items="${cvo}">
				<form action="" method="post">
					<tr class="item">
						<td><input type="checkbox" class="checkbox" /></td>
						<td>getImage</td>
						<td>${vo.pvo.pd_name}</td>
						<td class="price">${vo.pvo.pd_price}</td>
						<td><input type="hidden" name="p_num"
							value="${vo.pvo.pd_idx}" /> <input type="hidden" name="c_num"
							value="${vo.ca_idx}" class="ca_idx" /> <input type="number"
							class="count" name="count" value="${vo.ca_cnt}" min="1"
							onchange="calculateTotal(this)" />
							<button type="button" class="btn" onclick="increase(this)">△</button>
							<button type="button" class="btn" onclick="decrease(this)">▽</button>
						</td>
						<td class="total">${vo.pvo.pd_price * vo.ca_cnt}원</td>
						<td><button type="button" class="btn cancel"
								 onclick="javascript:if(confirm('삭제하시겠습니까?')){location.href='?type=cartDelete&us_idx=${vo.us_idx}&ca_idx=${vo.ca_idx}'}">삭제</button></td>

					</tr>
				</form>
			</c:forEach>
		</c:if>

		<c:if test="${cvo == null}">
			<tr class="no_item">
				<td colspan="7"><b>장바구니가 비었습니다.</b></td>
			</tr>
		</c:if>
	</tbody>
</table>

<div class="btn_div">
	<button id="delete_Btn" class="btn submit">선택상품삭제</button>
	<button id="deleteAll_Btn" class="btn cancel">장바구니비우기</button>
</div>
<div>
	<div>장바구니 상품 ${fn:length(cvo)} 개</div>
	<br />
	<div>
		합계금액 : <span id="totalSum">0</span>
	</div>
</div>
<br />
<div class="btn_div">
	<button class="btn submit">선택한 상품 주문</button>
</div>

<%@include file="/jsp/common/footer.jsp"%>
<script>
	function increase(button) {
		let countElement = button.parentElement.querySelector('.count');
		countElement.value = parseInt(countElement.value) + 1;
		calculateTotal(countElement);
	}

	function decrease(button) {
		let countElement = button.parentElement.querySelector('.count');
		if (parseInt(countElement.value) > 1) {
			countElement.value = parseInt(countElement.value) - 1;
			calculateTotal(countElement);
		}
	}

	function calculateTotal(countElement) {
		let row = countElement.closest('tr');
		let price = parseInt(row.querySelector('.price').textContent);
		let count = parseInt(countElement.value);
		let total = price * count;
		row.querySelector('.total').textContent = total + " 원";
		calculateTotalSum();
	}

	function calculateTotalSum() {
		let totalSum = 0;
		document.querySelectorAll('.total').forEach(function(totalElement) {
			totalSum += parseInt(totalElement.textContent);
		});
		document.getElementById('totalSum').textContent = totalSum + " 원";
	}

	// 페이지 로드 시 총합 계산
	document.addEventListener("DOMContentLoaded", function() {
		calculateTotalSum();
	});
	//장바구니 리스트 선택 삭제
	$(document).ready(function() {
		$("#delete_Btn").on('click', function() {
			var ca_idx_array = [];

			$(".checkbox:checked").each(function() {
				var $row = $(this).closest('tr');
				var ca_idx = $row.find('.ca_idx').val();
				ca_idx_array.push(ca_idx);

			});

			if (ca_idx_array.length > 0) {
				$.ajax({
					url : '?type=cartselectDelete', // 수정된 서버의 URL
					type : 'POST',
					data : {
						ca_idx_list : ca_idx_array
					},
					traditional : true,
					success : function(response) {
						
						alert('선택된 장바구니가 삭제되었습니다.');
						location.reload(); // 성공 후 페이지 새로고침
					},
					error : function() {
						
						alert('장바구니 삭제에 실패했습니다.');
					}
				});
			} else {
				alert('삭제할 상품을 선택하세요.');
			}
		});

	});
	//장바구니 모두 비우기
	$("#deleteAll_Btn").on('click', function() {
		var ca_idx_Array = [];

		// 모든 class="ca_idx" 요소를 선택하고, 각 요소의 값을 배열에 추가합니다.
		$(".ca_idx").each(function() {
			var ca_idx = $(this).val(); // 각 요소의 값을 가져옵니다.
			ca_idx_Array.push(ca_idx); // 값을 배열에 추가합니다.
		});

		console.log(ca_idx_Array); // 배열을 콘솔에 출력하여 확인합니다.

		if (ca_idx_Array.length > 0) {
			$.ajax({
				url : '?type=cartallDelete', 
				type : 'POST',
				data : {
					ca_idx_list : ca_idx_Array
				},
				traditional : true,
				success : function(response) {
				
					alert('장바구니가 비워졌습니다');
					location.reload(); // 성공 후 페이지 새로고침
				},
				error : function() {
					
					alert('장바구니가 비우는데 실패했습니다.');
				}
			});
		} else {
			alert('장바구니가 이미 비워져있습니다.');
		}

	});
</script>
