package kissco.store.jp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kissco.store.jp.model.CommentVO;
import kissco.store.jp.model.UserVO;
import kissco.store.jp.service.CommentService;
import kissco.store.jp.service.UserService;

@Controller
@RequestMapping("/comment")
public class CommentController {

	@Autowired
	CommentService commentService;

	@Autowired
	UserService userService;

	// 코멘트 추가
	@PostMapping(value = "/upload")
	@ResponseBody
	public boolean uploadComment(int product_no, String content) {

		System.out.println("product_no: " + product_no);
		System.out.println("content: " + content);

		CommentVO comment = new CommentVO();

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO user = userService.getUserById(authentication.getName());
		int user_no = user.getUser_no();
		comment.setUser_no(user_no);
		comment.setProduct_no(product_no);
		comment.setContent(content);
		return commentService.uploadComment(comment);
	}

	// 코멘트 리스트
	@PostMapping(value = "/list")
	@ResponseBody
	public List<CommentVO> commentList(int product_no) {

		return commentService.commentList(product_no);
	}

	// 코멘트 리스트
	@PostMapping(value = "/delete")
	@ResponseBody
	public boolean deleteComment(int comment_no) {

		return commentService.deleteComment(comment_no);
	}

	// 코멘트 추가
	@PostMapping(value = "/update")
	@ResponseBody
	public boolean updateComment(int comment_no, String content) {

		return commentService.uploadComment(comment_no, content);
	}

}
