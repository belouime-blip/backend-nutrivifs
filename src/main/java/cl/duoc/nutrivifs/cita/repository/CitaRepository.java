package cl.duoc.nutrivifs.cita.repository;
import cl.duoc.nutrivifs.cita.model.Cita;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface CitaRepository extends JpaRepository<Cita,Long> { List<Cita> findAllByOrderByFechaSolicitudDesc(); List<Cita> findByCorreoIgnoreCaseOrderByFechaSolicitudDesc(String correo); }
