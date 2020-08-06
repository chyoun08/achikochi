package kissco.store.jp.service;

import java.util.List;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import kissco.store.jp.dao.AlarmDAO;
import kissco.store.jp.dao.UserDAO;
import kissco.store.jp.model.AlarmVO;
import kissco.store.jp.model.ProductVO;
import kissco.store.jp.model.UserVO;
import kissco.store.jp.model.WishlistVO;

@Service
public class UserService {

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	UserDAO userDao;
	
	@Autowired
	AlarmDAO alarmDao;

	public UserVO getUserByNo(int user_no) {
		return userDao.getUserByNo(user_no);
	}

	public UserVO getUserById(String user_id) {
		return userDao.getUserById(user_id);
	}

	public boolean registUser(UserVO user) {
		return userDao.registUser(user);
	}

	public boolean updateUser(UserVO user) {
		return userDao.updateUser(user);
	}

	public boolean deleteUser(int user_no) {
		return userDao.deleteUser(user_no);
	}

	public boolean mailSendWithUserKey(UserVO user, HttpServletRequest request) {
		String key = getKey(false, 20);
		userDao.getKey(user.getUser_id(), key);
		MimeMessage mail = mailSender.createMimeMessage();
		String htmlStr = "<h2>email인증 번호 발급 창입니다</h2>" + "<h3>" + user.getUser_id() + "님</h3>"
				+ "<p>인증 버튼 클릭시 인증 가능: <br/>" + "<a href='http:localhost:8080" + request.getContextPath()
				+ "/user/key_alter?" + "user_id=" + user.getUser_id() + "&user_key=" + key + "'>인증하기</a></p>";
		try {
			mail.setSubject("[본인인증] KISSCO 가입", "utf-8");
			mail.setText(htmlStr, "utf-8", "html");
			mail.addRecipient(RecipientType.TO, new InternetAddress(user.getMail()));
			mailSender.send(mail);
			return true;
		} catch (MessagingException e) {
			System.out.println("MAIL SEND FAIL!!");
			e.printStackTrace();
			return false;
		}
	}

	public boolean mailSendWithMailByFindPassword(String _email, HttpServletRequest request) {
		String key = getKey(false, 7);
		userDao.alterUserPwByMail(key, _email);
		MimeMessage mail = mailSender.createMimeMessage();
		String htmlStr = "<h2>email 비밀번호 발급 창입니다</h2>" + "<h1> 변경된 비밀번호로 로그인해주세요! </h1>" + "<p>수정된 비밀 번호는 <br/>" + key
				+ " 입니다.<br/> 수정을 원하신다면 개인정보창에서 수정해주세요.</p>";
		try {
			mail.setSubject("[본인인증] KISSCO 비밀번호 찾기", "utf-8");
			mail.setText(htmlStr, "utf-8", "html");
			mail.addRecipient(RecipientType.TO, new InternetAddress(_email));
			mailSender.send(mail);
			return true;
		} catch (MessagingException e) {
			System.out.println("MAIL SEND FAIL!!");
			e.printStackTrace();
			return false;
		}
	}

	private int size;
	private boolean lowerCheck;

	private String init() {
		Random ran = new Random();
		StringBuffer sb = new StringBuffer();
		int num = 0;
		do {
			num = ran.nextInt(75) + 48;
			if ((num >= 48 && num <= 57) || (num >= 65 && num <= 90) || (num >= 97 && num <= 122)) {
				sb.append((char) num);
			} else {
				continue;
			}
		} while (sb.length() < size);
		if (lowerCheck) {
			return sb.toString().toLowerCase();
		}
		return sb.toString();
	}

	public String getKey(boolean lowerCheck, int size) {
		this.lowerCheck = lowerCheck;
		this.size = size;
		return init();
	}

	public boolean alter_userKey(String user_id, String key) {
		return userDao.alter_userKey(user_id, key);
	}

	public List<AlarmVO> getAlarmList(String user_id){
		return alarmDao.getAlarmList(user_id);
	}
	
	public boolean addAlarm(int product_no, int user_no) {
		return alarmDao.addAlarm(product_no, user_no);
	}
	
	public boolean deleteAlarm(int product_no) {
		return alarmDao.deleteAlarm(product_no);
	}
	
	public boolean deleteAlarmALL(int user_no) {
		return alarmDao.delteAlarmALL(user_no);
	}
	
	public List<ProductVO> getMySellList(String user_id){
		return userDao.getMySellList(user_id);
	}
	
	// 여기서부터 윤호형꺼

	public List<WishlistVO> getWishlistVOs(int user_no) {
		return userDao.getWishList(user_no);
	}

	public boolean insertWishlist(int user_no, int product_no) {
		return userDao.insertWishlist(user_no, product_no);
	}
	
	public boolean deleteWishlist(int product_no, int user_no) {
		return userDao.deleteWishlist(product_no, user_no);
	}

	public boolean deleteWishlistALL(int user_no) {
		return userDao.deleteWishlistALL(user_no);
	}
}
