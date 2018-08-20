package com.analysis.manager.controllers;


import com.analysis.manager.Service.AnimalsServiceImpl;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.modle.User;
//import com.analysis.manager.Dao.UserDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Class UserController
 */
@Controller
public class UserController {
    @Autowired
    private UserService userService;

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);


    @RequestMapping(value = "/users")
    public String view(Model model)
    {
        model.addAttribute("users", userService.findAll());

        return "users";
    }

    @RequestMapping(value="/users/{id}/delete")
    public String delete(@PathVariable long id, Model model) {
        try {
            User user = userService.findById(id);

            if (user != null) {
                userService.delete(user);
                model.addAttribute("success_message", "User succesfully deleted!");
            } else {
                model.addAttribute("error_message", "can not find user to delete");
            }
        }
        catch (Exception ex) {
            logger.error(ex.getMessage());
            model.addAttribute("error_message", "error while deleting user from DB");
        }

        return view(model);
    }

} // class UserController
