package kissco.store.jp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kissco.store.jp.dao.CommentDAO;
import kissco.store.jp.model.CommentVO;

@Service
public class CommentService {
	
	@Autowired
	CommentDAO commentdao;
	
	public boolean uploadComment(CommentVO comment) {
		// TODO Auto-generated method stub
		return commentdao.uploadComment(comment);
	}


	public List<CommentVO> commentList(int product_no) {
		// TODO Auto-generated method stub
		return commentdao.commentList(product_no);
	}


	public boolean deleteComment(int comment_no) {
		// TODO Auto-generated method stub
		return commentdao.deleteComment(comment_no);
	}


	public boolean uploadComment(int comment_no, String content) {
		// TODO Auto-generated method stub
		return commentdao.uploadComment(comment_no,content);
	}

}
