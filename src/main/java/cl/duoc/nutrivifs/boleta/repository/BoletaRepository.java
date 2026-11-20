package cl.duoc.nutrivifs.boleta.repository;

import cl.duoc.nutrivifs.boleta.model.Boleta;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BoletaRepository extends JpaRepository<Boleta, Long> {

    List<Boleta> findByUsuario_MailOrderByFechaDesc(String mail);

    boolean existsByUsuario_Id(Long idUsuario);
}
