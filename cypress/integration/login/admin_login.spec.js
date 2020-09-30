/// <reference types="cypress" />

context('Admin login', () => {
  before(() => {
    cy.clearCookies()
  })
  beforeEach(() => {
    cy.visit('http://localhost:3000/users/sign_in')
  })

  it('use valid admin password', () => {
    cy.loginAsAdmin()
    cy.get('.alert.alert-info').should('contain', 'Sesión iniciada.')
    cy.get('.navbar-header').should('not.contain', 'Organizations')
    cy.get('.navbar-header').should('contain', 'Urnas Virtuales')
    cy.get('.navbar-header').should('contain', 'Grupos')
    cy.get('.navbar-header').should('contain', 'Cerrar sesión')
  })

  it('use valid superadmin password', () => {
    cy.loginAsSuperadmin()
    cy.get('.alert.alert-info').should('contain', 'Sesión iniciada.')
    cy.get('.navbar-header').should('contain', 'Organizations')
    cy.get('.navbar-header').should('contain', 'Urnas Virtuales')
    cy.get('.navbar-header').should('contain', 'Grupos')
    cy.get('.navbar-header').should('contain', 'Cerrar sesión')
  })

  it('use invalid password', () => {
    cy.login('admin@example.com', 'invalidpass')
    cy.get('.alert.alert-danger').should('contain', 'Email o contraseña inválidos.')
  })

  it('logout', () => {
    cy.loginAsAdmin()
    cy.logout()
  })
})
