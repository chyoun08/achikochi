package kissco.store.jp.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class ProductVO {
	


	private int product_no;
	private int user_no;
	private int category;
	private double lat;
	private double lng;
	private String title;
	private int price;
	private String content;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone="Asia/Seoul")
	private Date date;
	private String photopath;
	private String sumnail;
	
}
