package kissco.store.jp.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kissco.store.jp.model.AlarmVO;
import kissco.store.jp.model.UserVO;
import kissco.store.jp.service.ProductService;
import kissco.store.jp.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	UserService userService;

	@GetMapping(value = "/findAccount")
	public String findAccount() {
		return "findAccount";
	}
	
	@PostMapping(value="/findAccount")
	public String findAccount(@RequestParam("mail") String email, HttpServletRequest request) {
		System.out.println("EMail : "+email);
		if(userService.mailSendWithMailByFindPassword(email, request)) {
			System.out.println("비밀번호 변경 성공!! "+email);
			return "home";
		}else {
			System.out.println("변경 실패");
			return "home";
		}
	}
	
	@GetMapping(value = "/regist")
	public String regist() {
		return "regist";
	}
	
	
	@GetMapping(value="/register")
	public String userRegister() {
		return "user/register";
	}

	@PostMapping(value="/register")
	@ResponseBody
	public boolean userRegister(UserVO user,HttpServletRequest request) {
		
		if(userService.registUser(user)) {
			return userService.mailSendWithUserKey(user, request);
		}
		return false;
	}
	
	@PostMapping(value="/delete")
	@ResponseBody
	public boolean userDelete(int user_no) {
		return userService.deleteUser(user_no);
	}
	
	@GetMapping(value="/userInfo")
	public String userInfo(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserVO user = userService.getUserById(authentication.getName());
		
		model.addAttribute("user",user);
		return "userInfo";
	}
	
	@GetMapping(value="/update")
	public String userUpdate(Model model, HttpSession session) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String user_id = authentication.getName();
		UserVO user = userService.getUserById(user_id);
		
		model.addAttribute("user",user);
		return "user/update";
	}
	
	@PostMapping(value="/update")
	@ResponseBody
	public boolean userUpdate(UserVO user) {
		boolean check = userService.updateUser(user);
		return check;
	}
	
	@GetMapping(value="/key_alter")
	public String userAccept(String user_id,String user_key) {
		
		if(userService.alter_userKey(user_id, user_key)) {
			return "home";
		}else {
			System.out.println("user_id : "+user_id+" user_key : "+user_key);
			return "home";
		}
	}
	
	@PostMapping(value="/alarm/add")
	@ResponseBody
	public boolean addAlarm(int product_no, int user_no) {
		
		return userService.addAlarm(product_no, user_no);
	}
	
	@GetMapping(value="/alarm/list")
	@ResponseBody
	public List<AlarmVO> getAlarmList(){
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		return userService.getAlarmList(authentication.getName());
	}
	
	@GetMapping(value="/alarm/delete")
	@ResponseBody
	public boolean delteAlarm(int product_no) {
		return userService.deleteAlarm(product_no);
	}
	
	@GetMapping(value="/alarm/deleteALL")
	@ResponseBody
	public boolean delteAlarmALL(int user_no) {
		return userService.deleteAlarmALL(user_no);
	}
	
	@GetMapping(value="/mySellList")
	public String mySellList(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		model.addAttribute("sellList",userService.getMySellList(authentication.getName()));
		return "mySellList";
	}
}
