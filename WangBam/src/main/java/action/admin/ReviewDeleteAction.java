package action.admin;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.Action;
import mybatis.dao.BoardsDAO;
import mybatis.vo.BoardsVO;

public class ReviewDeleteAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String bo_idx = request.getParameter("bo_idx");
		String[] bo_idx_ar = request.getParameterValues("bo_idx_ar");

		if (bo_idx != null) {
			BoardsDAO.delete(bo_idx);
		}

		if (bo_idx_ar != null && bo_idx_ar.length > 0) {
			// 삭제 로직 구현
			for (String bo_idx2 : bo_idx_ar) {
				BoardsDAO.delete(bo_idx2);

			}
		}

		return "/jsp/admin/reviewDelete.jsp"; // "admin?type=reviewList";
	}

}
