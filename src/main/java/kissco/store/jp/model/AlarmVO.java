package kissco.store.jp.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class AlarmVO {

	private int alarm_no;
	private int product_no;
	
	//출력을 위해 필요한 부분
	private String sumnail;
	private int user_no;
	private String nickname;
	private String title;
	private int price;
	
	private int alarm;
}
