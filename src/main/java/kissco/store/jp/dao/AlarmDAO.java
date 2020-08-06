package kissco.store.jp.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import kissco.store.jp.model.AlarmVO;

@Repository
public class AlarmDAO {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	//알림창 추가
	public boolean addAlarm(int product_no, int user_no) {
		String sql = "INSERT INTO alarms ( product_no, user_no ) VALUES ( ?, ? );";

		return (jdbcTemplate.update(sql, product_no, user_no) == 1);

	}

	public List<AlarmVO> getAlarmList(String user_id) {

		String sql = "select p.product_no, p.sumnail, p.user_no, u.nickname, p.title, p.price, "
				+ " (select count(*) from alarms a where a.product_no =p.product_no) alarm "
				+ " from product p, users u where u.user_id = ? and p.user_no = u.user_no;";

		return jdbcTemplate.query(sql, new RowMapper<AlarmVO>() {

			@Override
			public AlarmVO mapRow(ResultSet rs, int rowNum) throws SQLException {

				AlarmVO alarm = new AlarmVO();
				alarm.setProduct_no(rs.getInt("product_no"));

				alarm.setSumnail(rs.getString("sumnail"));
				alarm.setUser_no(rs.getInt("user_no"));
				alarm.setNickname(rs.getString("nickname"));
				alarm.setTitle(rs.getString("title"));
				alarm.setPrice(rs.getInt("price"));
				alarm.setAlarm(rs.getInt("alarm"));
				return alarm;
			}
		}, user_id);
	}

	public boolean deleteAlarm(int product_no) {
		String sql = "delete from alarms where product_no in ( ? )";
		return (jdbcTemplate.update(sql, product_no) == 1);
	}

	public boolean delteAlarmALL(int user_no) {
		String sql = "delete from alarms where user_no in ( ? )";
		return (jdbcTemplate.update(sql, user_no) == 1);
	}
}
