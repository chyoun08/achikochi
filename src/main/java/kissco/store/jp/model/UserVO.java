package kissco.store.jp.model;

import javax.validation.constraints.NotEmpty;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class UserVO {
	
	private int user_no;
	
	private String authority="ROLE_USER";
	
	@NotEmpty(message="UserID must not be null")
	private String user_id;
	
	@NotEmpty(message="Password must not be null")
	private String user_pw;
	
	@NotEmpty(message="Nickname must not be null")
	private String nickname;
	
	@NotEmpty(message="The mail must not be null")
	private String mail;
	
	private double lat = 0;
	
	private double lng = 0;
	
	private String introduce = "";
	
	private String user_key = "N";
	
	private int enabled=0;
}
